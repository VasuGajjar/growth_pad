import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin PortraitModeMixin on StatelessWidget {
  void portraitModeOnly() => _portraitModeOnly();
}

mixin PortraitStatefulModeMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    _portraitModeOnly();
    super.initState();
  }

  @override
  void dispose() {
    _enableRotation();
  }
}

/// blocks rotation; sets orientation to: portrait
void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void _enableRotation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}
