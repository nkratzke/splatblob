// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library analyzer.source.embedder;

import 'dart:collection' show HashMap;
import 'dart:core' hide Resource;

import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer/source/package_map_provider.dart'
    show PackageMapProvider;
import 'package:analyzer/src/context/context.dart';
import 'package:analyzer/src/generated/engine.dart';
import 'package:analyzer/src/generated/java_core.dart';
import 'package:analyzer/src/generated/java_engine.dart';
import 'package:analyzer/src/generated/java_io.dart' show JavaFile;
import 'package:analyzer/src/generated/sdk.dart';
import 'package:analyzer/src/generated/source.dart';
import 'package:analyzer/src/generated/source_io.dart' show FileBasedSource;
import 'package:yaml/yaml.dart';

const String _DART_COLON_PREFIX = 'dart:';
const String _EMBEDDED_LIB_MAP_KEY = 'embedded_libs';

/// Check if this map defines embedded libraries.
bool definesEmbeddedLibs(Map map) => map[_EMBEDDED_LIB_MAP_KEY] != null;

/// An SDK backed by URI mappings derived from an `_embedder.yaml` file.
class EmbedderSdk implements DartSdk {
  /// The resolver associated with this SDK.
  EmbedderUriResolver _resolver;

  /// The [AnalysisContext] used for this SDK's sources.
  InternalAnalysisContext _analysisContext;

  final LibraryMap _librariesMap = new LibraryMap();

  final Map<String, String> _urlMappings = new HashMap<String, String>();

  /// Analysis options for this SDK.
  AnalysisOptions analysisOptions;

  EmbedderSdk([Map<Folder, YamlMap> embedderYamls]) {
    embedderYamls?.forEach(_processEmbedderYaml);
    _resolver = new EmbedderUriResolver._forSdk(this);
  }

  @override
  AnalysisContext get context {
    if (_analysisContext == null) {
      _analysisContext = new SdkAnalysisContext(analysisOptions);
      SourceFactory factory = new SourceFactory([_resolver]);
      _analysisContext.sourceFactory = factory;

      ChangeSet changeSet = new ChangeSet();
      for (String uri in uris) {
        changeSet.addedSource(factory.forUri(uri));
      }
      _analysisContext.applyChanges(changeSet);
    }
    return _analysisContext;
  }

  @override
  List<SdkLibrary> get sdkLibraries => _librariesMap.sdkLibraries;

  // TODO(danrubel) Determine SDK version
  @override
  String get sdkVersion => '0';

  @override
  List<String> get uris => _librariesMap.uris;

  /// The url mappings for this SDK.
  Map<String, String> get urlMappings => _urlMappings;

  @override
  Source fromFileUri(Uri uri) {
    JavaFile file = new JavaFile.fromUri(uri);
    String filePath = file.getAbsolutePath();

    String path;
    for (SdkLibrary library in _librariesMap.sdkLibraries) {
      String libraryPath = library.path.replaceAll('/', JavaFile.separator);
      if (filePath == libraryPath) {
        path = library.shortName;
        break;
      }
    }
    if (path == null) {
      for (SdkLibrary library in _librariesMap.sdkLibraries) {
        String libraryPath = library.path.replaceAll('/', JavaFile.separator);
        int index = libraryPath.lastIndexOf(JavaFile.separator);
        if (index == -1) {
          continue;
        }
        String prefix = libraryPath.substring(0, index + 1);
        if (!filePath.startsWith(prefix)) {
          continue;
        }
        var relPath = filePath
            .substring(prefix.length)
            .replaceAll(JavaFile.separator, '/');
        path = '${library.shortName}/$relPath';
        break;
      }
    }

    if (path != null) {
      try {
        return new FileBasedSource(file, parseUriWithException(path));
      } on URISyntaxException catch (exception, stackTrace) {
        AnalysisEngine.instance.logger.logInformation(
            "Failed to create URI: $path",
            new CaughtException(exception, stackTrace));
        return null;
      }
    }
    return null;
  }

  @override
  SdkLibrary getSdkLibrary(String dartUri) => _librariesMap.getLibrary(dartUri);

  @override
  Source mapDartUri(String dartUri) {
    String libraryName;
    String relativePath;
    int index = dartUri.indexOf('/');
    if (index >= 0) {
      libraryName = dartUri.substring(0, index);
      relativePath = dartUri.substring(index + 1);
    } else {
      libraryName = dartUri;
      relativePath = "";
    }
    SdkLibrary library = getSdkLibrary(libraryName);
    if (library == null) {
      return null;
    }
    String srcPath;
    if (relativePath.isEmpty) {
      srcPath = library.path;
    } else {
      String libraryPath = library.path;
      int index = libraryPath.lastIndexOf(JavaFile.separator);
      if (index == -1) {
        index = libraryPath.lastIndexOf('/');
        if (index == -1) {
          return null;
        }
      }
      String prefix = libraryPath.substring(0, index + 1);
      srcPath = '$prefix$relativePath';
    }
    String filePath = srcPath.replaceAll('/', JavaFile.separator);
    try {
      JavaFile file = new JavaFile(filePath);
      return new FileBasedSource(file, parseUriWithException(dartUri));
    } on URISyntaxException {
      return null;
    }
  }

  /// Install the mapping from [name] to [libDir]/[file].
  void _processEmbeddedLibs(String name, String file, Folder libDir) {
    if (!name.startsWith(_DART_COLON_PREFIX)) {
      // SDK libraries must begin with 'dart:'.
      return;
    }
    String libPath = libDir.canonicalizePath(file);
    _urlMappings[name] = libPath;
    SdkLibraryImpl library = new SdkLibraryImpl(name);
    library.path = libPath;
    _librariesMap.setLibrary(name, library);
  }

  /// Given the 'embedderYamls' from [EmbedderYamlLocator] check each one for the
  /// top level key 'embedded_libs'. Under the 'embedded_libs' key are key value
  /// pairs. Each key is a 'dart:' library uri and each value is a path
  /// (relative to the directory containing `_embedder.yaml`) to a dart script
  /// for the given library. For example:
  ///
  /// embedded_libs:
  ///   'dart:io': '../../sdk/io/io.dart'
  ///
  /// If a key doesn't begin with `dart:` it is ignored.
  void _processEmbedderYaml(Folder libDir, YamlMap map) {
    YamlNode embedded_libs = map[_EMBEDDED_LIB_MAP_KEY];
    if (embedded_libs is YamlMap) {
      embedded_libs.forEach((k, v) => _processEmbeddedLibs(k, v, libDir));
    }
  }
}

/// Given the 'embedderYamls' from [EmbedderYamlLocator] check each one for the
/// top level key 'embedded_libs'. Under the 'embedded_libs' key are key value
/// pairs. Each key is a 'dart:' library uri and each value is a path
/// (relative to the directory containing `_embedder.yaml`) to a dart script
/// for the given library. For example:
///
/// embedded_libs:
///   'dart:io': '../../sdk/io/io.dart'
///
/// If a key doesn't begin with `dart:` it is ignored.
///
class EmbedderUriResolver implements DartUriResolver {
  EmbedderSdk _embedderSdk;
  DartUriResolver _dartUriResolver;

  /// Construct a [EmbedderUriResolver] from a package map
  /// (see [PackageMapProvider]).
  EmbedderUriResolver(Map<Folder, YamlMap> embedderMap) :
      this._forSdk(new EmbedderSdk(embedderMap));

  /// (Provisional API.)
  EmbedderUriResolver._forSdk(this._embedderSdk) {
    _dartUriResolver = new DartUriResolver(_embedderSdk);
  }

  @override
  DartSdk get dartSdk => _embedderSdk;

  /// Number of embedded libraries.
  int get length => _embedderSdk?.urlMappings?.length ?? 0;

  @override
  Source resolveAbsolute(Uri uri, [Uri actualUri]) =>
      _dartUriResolver.resolveAbsolute(uri, actualUri);

  @override
  Uri restoreAbsolute(Source source) {
    String path = source.fullName;
    if (path.length > 3 && path[1] == ':' && path[2] == '\\') {
      path = '/${path[0]}:${path.substring(2).replaceAll('\\', '/')}';
    }
    Source sdkSource = dartSdk.fromFileUri(Uri.parse('file://$path'));
    return sdkSource?.uri;
  }
}

/// Given a packageMap, check in each package's lib directory for the
/// existence of an `_embedder.yaml` file. If the file contains a top level
/// YamlMap, it will be added to the [embedderYamls] map.
class EmbedderYamlLocator {
  static const String EMBEDDER_FILE_NAME = '_embedder.yaml';

  /// Map from package's library directory to the parsed YamlMap.
  final Map<Folder, YamlMap> embedderYamls = new HashMap<Folder, YamlMap>();

  EmbedderYamlLocator(Map<String, List<Folder>> packageMap) {
    if (packageMap != null) {
      refresh(packageMap);
    }
  }

  /// Programatically add an _embedder.yaml mapping.
  void addEmbedderYaml(Folder libDir, String embedderYaml) {
    _processEmbedderYaml(libDir, embedderYaml);
  }

  void refresh(Map<String, List<Folder>> packageMap) {
    // Clear existing.
    embedderYamls.clear();
    if (packageMap == null) {
      return;
    }
    packageMap.forEach(_processPackage);
  }

  /// Given the yaml for an embedder ([embedderYaml]) and a folder
  /// ([libDir]), setup the uri mapping.
  void _processEmbedderYaml(Folder libDir, String embedderYaml) {
    YamlNode yaml;
    try {
      yaml = loadYaml(embedderYaml);
    } catch (_) {
      return;
    }
    if (yaml is! YamlMap) {
      return;
    }
    embedderYamls[libDir] = yaml;
  }

  /// Given a package [name] and a list of folders ([libDirs]),
  /// add any found `_embedder.yaml` files.
  void _processPackage(String name, List<Folder> libDirs) {
    for (Folder libDir in libDirs) {
      String embedderYaml = _readEmbedderYaml(libDir);
      if (embedderYaml != null) {
        _processEmbedderYaml(libDir, embedderYaml);
      }
    }
  }

  /// Read the contents of [libDir]/[EMBEDDER_FILE_NAME] as a string.
  /// Returns null if the file doesn't exist.
  String _readEmbedderYaml(Folder libDir) {
    File file = libDir.getChild(EMBEDDER_FILE_NAME);
    try {
      return file.readAsStringSync();
    } on FileSystemException {
      // File can't be read.
      return null;
    }
  }
}
