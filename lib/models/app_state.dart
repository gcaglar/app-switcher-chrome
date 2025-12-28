import 'package:flutter/foundation.dart';

enum AppType { todo, ticTacToe, snake }

class ViewportPreset {
  final String name;
  final double width;
  final double height;

  const ViewportPreset({
    required this.name,
    required this.width,
    required this.height,
  });

  static const List<ViewportPreset> presets = [
    ViewportPreset(name: 'iPhone SE', width: 375, height: 667),
    ViewportPreset(name: 'iPhone 14', width: 390, height: 844),
    ViewportPreset(name: 'Pixel 7', width: 412, height: 915),
  ];
}

class AppState extends ChangeNotifier {
  AppType _currentApp = AppType.todo;
  ViewportPreset _viewportPreset = ViewportPreset.presets[0];

  AppType get currentApp => _currentApp;
  ViewportPreset get viewportPreset => _viewportPreset;

  void setCurrentApp(AppType app) {
    _currentApp = app;
    notifyListeners();
  }

  void setViewportPreset(ViewportPreset preset) {
    _viewportPreset = preset;
    notifyListeners();
  }
}
