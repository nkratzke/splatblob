// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:async/async.dart';

import '../environment.dart';

/// The default environment for platform plugins.
class PluginEnvironment implements Environment {
  final supportsDebugging = false;

  const PluginEnvironment();

  Uri get observatoryUrl => throw new UnsupportedError(
      "PluginEnvironment.observatoryUrl is not supported.");

  Uri get remoteDebuggerUrl => throw new UnsupportedError(
      "PluginEnvironment.remoteDebuggerUrl is not supported.");

  CancelableOperation displayPause() =>
      throw new UnsupportedError(
          "PluginEnvironment.displayPause is not supported.");
}
