import 'package:flutter/material.dart';
import 'package:noxio/pages/game_page.dart';
import 'package:noxio/pages/home_page.dart';
import 'package:noxio/pages/settings_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/game':
        return MaterialPageRoute(builder: (_) => GamePage(params: settings.arguments));
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      default:
        return _errorRoute(settings.name);
    }
  }

  static Route<dynamic> _errorRoute(String name) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error 404'),
        ),
        body: Center(
          child: Text('Route $name is undefined'),
        ),
      );
    });
  }
}
