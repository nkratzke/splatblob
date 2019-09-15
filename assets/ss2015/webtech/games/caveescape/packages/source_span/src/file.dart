// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library source_span.file;

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:path/path.dart' as p;

import 'colors.dart' as colors;
import 'location.dart';
import 'span.dart';
import 'span_mixin.dart';
import 'span_with_context.dart';
import 'utils.dart';

// Constants to determine end-of-lines.
const int _LF = 10;
const int _CR = 13;

/// A class representing a source file.
///
/// This doesn't necessarily have to correspond to a file on disk, just a chunk
/// of text usually with a URL associated with it.
class SourceFile {
  /// The URL where the source file is located.
  ///
  /// This may be null, indicating that the URL is unknown or unavailable.
  final Uri url;

  /// An array of offsets for each line beginning in the file.
  ///
  /// Each offset refers to the first character *after* the newline. If the
  /// source file has a trailing newline, the final offset won't actually be in
  /// the file.
  final _lineStarts = <int>[0];

  /// The code points of the characters in the file.
  final Uint32List _decodedChars;

  /// The length of the file in characters.
  int get length => _decodedChars.length;

  /// The number of lines in the file.
  int get lines => _lineStarts.length;

  /// Creates a new source file from [text].
  ///
  /// [url] may be either a [String], a [Uri], or `null`.
  SourceFile(String text, {url})
      : this.decoded(text.runes, url: url);

  /// Creates a new source file from a list of decoded characters.
  ///
  /// [url] may be either a [String], a [Uri], or `null`.
  SourceFile.decoded(Iterable<int> decodedChars, {url})
      : url = url is String ? Uri.parse(url) : url,
        _decodedChars = new Uint32List.fromList(decodedChars.toList()) {
    for (var i = 0; i < _decodedChars.length; i++) {
      var c = _decodedChars[i];
      if (c == _CR) {
        // Return not followed by newline is treated as a newline
        var j = i + 1;
        if (j >= _decodedChars.length || _decodedChars[j] != _LF) c = _LF;
      }
      if (c == _LF) _lineStarts.add(i + 1);
    }
  }

  /// Returns a span in [this] from [start] to [end] (exclusive).
  ///
  /// If [end] isn't passed, it defaults to the end of the file.
  FileSpan span(int start, [int end]) {
    if (end == null) end = length - 1;
    return new FileSpan._(this, start, end);
  }

  /// Returns a location in [this] at [offset].
  FileLocation location(int offset) => new FileLocation._(this, offset);

  /// Gets the 0-based line corresponding to [offset].
  int getLine(int offset) {
    if (offset < 0) {
      throw new RangeError("Offset may not be negative, was $offset.");
    } else if (offset > length) {
      throw new RangeError("Offset $offset must not be greater than the number "
          "of characters in the file, $length.");
    }
    return binarySearch(_lineStarts, (o) => o > offset) - 1;
  }

  /// Gets the 0-based column corresponding to [offset].
  ///
  /// If [line] is passed, it's assumed to be the line containing [offset] and
  /// is used to more efficiently compute the column.
  int getColumn(int offset, {int line}) {
    if (offset < 0) {
      throw new RangeError("Offset may not be negative, was $offset.");
    } else if (offset > length) {
      throw new RangeError("Offset $offset must be not be greater than the "
          "number of characters in the file, $length.");
    }

    if (line == null) {
      line = getLine(offset);
    } else if (line < 0) {
      throw new RangeError("Line may not be negative, was $line.");
    } else if (line >= lines) {
      throw new RangeError("Line $line must be less than the number of "
          "lines in the file, $lines.");
    }

    var lineStart = _lineStarts[line];
    if (lineStart > offset) {
      throw new RangeError("Line $line comes after offset $offset.");
    }

    return offset - lineStart;
  }

  /// Gets the offset for a [line] and [column].
  ///
  /// [column] defaults to 0.
  int getOffset(int line, [int column]) {
    if (column == null) column = 0;

    if (line < 0) {
      throw new RangeError("Line may not be negative, was $line.");
    } else if (line >= lines) {
      throw new RangeError("Line $line must be less than the number of "
          "lines in the file, $lines.");
    } else if (column < 0) {
      throw new RangeError("Column may not be negative, was $column.");
    }

    var result = _lineStarts[line] + column;
    if (result > length ||
        (line + 1 < lines && result >= _lineStarts[line + 1])) {
      throw new RangeError("Line $line doesn't have $column columns.");
    }

    return result;
  }

  /// Returns the text of the file from [start] to [end] (exclusive).
  ///
  /// If [end] isn't passed, it defaults to the end of the file.
  String getText(int start, [int end]) =>
      new String.fromCharCodes(_decodedChars.sublist(start, end));
}

/// A [SourceLocation] within a [SourceFile].
///
/// Unlike the base [SourceLocation], [FileLocation] lazily computes its line
/// and column values based on its offset and the contents of [file].
///
/// A [FileLocation] can be created using [SourceFile.location].
class FileLocation extends SourceLocation {
  /// The [file] that [this] belongs to.
  final SourceFile file;

  Uri get sourceUrl => file.url;
  int get line => file.getLine(offset);
  int get column => file.getColumn(offset);

  FileLocation._(this.file, int offset)
      : super(offset) {
    if (offset > file.length) {
      throw new RangeError("Offset $offset must not be greater than the number "
          "of characters in the file, ${file.length}.");
    }
  }

  FileSpan pointSpan() => new FileSpan._(file, offset, offset);
}

/// A [SourceSpan] within a [SourceFile].
///
/// Unlike the base [SourceSpan], [FileSpan] lazily computes its line and column
/// values based on its offset and the contents of [file]. [FileSpan.message] is
/// also able to provide more context then [SourceSpan.message], and
/// [FileSpan.union] will return a [FileSpan] if possible.
///
/// A [FileSpan] can be created using [SourceFile.span].
class FileSpan extends SourceSpanMixin implements SourceSpanWithContext {
  /// The [file] that [this] belongs to.
  final SourceFile file;

  /// The offset of the beginning of the span.
  ///
  /// [start] is lazily generated from this to avoid allocating unnecessary
  /// objects.
  final int _start;

  /// The offset of the end of the span.
  ///
  /// [end] is lazily generated from this to avoid allocating unnecessary
  /// objects.
  final int _end;

  Uri get sourceUrl => file.url;
  int get length => _end - _start;
  FileLocation get start => new FileLocation._(file, _start);
  FileLocation get end => new FileLocation._(file, _end);
  String get text => file.getText(_start, _end);
  String get context => file.getText(file.getOffset(start.line),
      end.line == file.lines - 1 ? null : file.getOffset(end.line + 1));

  FileSpan._(this.file, this._start, this._end) {
    if (_end < _start) {
      throw new ArgumentError('End $_end must come after start $_start.');
    } else if (_end > file.length) {
      throw new RangeError("End $_end must not be greater than the number "
          "of characters in the file, ${file.length}.");
    } else if (_start < 0) {
      throw new RangeError("Start may not be negative, was $_start.");
    }
  }

  int compareTo(SourceSpan other) {
    if (other is! FileSpan) return super.compareTo(other);

    FileSpan otherFile = other;
    var result = _start.compareTo(otherFile._start);
    return result == 0 ? _end.compareTo(otherFile._end) : result;
  }

  SourceSpan union(SourceSpan other) {
    if (other is! FileSpan) return super.union(other);

    var span = expand(other);
    var beginSpan = span._start == _start ? this : other;
    var endSpan = span._end == _end ? this : other;

    if (beginSpan._end < endSpan._start) {
      throw new ArgumentError("Spans $this and $other are disjoint.");
    }

    return span;
  }

  bool operator ==(other) {
    if (other is! FileSpan) return super == other;
    return _start == other._start && _end == other._end &&
        sourceUrl == other.sourceUrl;
  }

  int get hashCode => _start.hashCode + 5 * _end.hashCode +
      7 * sourceUrl.hashCode;

  /// Returns a new span that covers both [this] and [other].
  ///
  /// Unlike [union], [other] may be disjoint from [this]. If it is, the text
  /// between the two will be covered by the returned span.
  FileSpan expand(FileSpan other) {
    if (sourceUrl != other.sourceUrl) {
      throw new ArgumentError("Source URLs \"${sourceUrl}\" and "
          " \"${other.sourceUrl}\" don't match.");
    }

    var start = math.min(this._start, other._start);
    var end = math.max(this._end, other._end);
    return new FileSpan._(file, start, end);
  }
}
