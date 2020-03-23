import 'package:flutter/material.dart';
import 'package:noxio/utils/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel with ChangeNotifier {
  SharedPreferences _prefs;
  String _themeName = NoxioThemes().map.keys.first;
  ThemeData _themeData = NoxioThemes().map.values.first;
  Color _primary = Colors.blue;
  Color _secondary = Colors.red;

  AppModel() {
    init();
  }


  void init() async {
    _prefs = await SharedPreferences.getInstance();
    _themeName = _prefs.getString('theme') ?? NoxioThemes().map.keys.first;
    _themeData = NoxioThemes().map['$_themeName'];

    int primaryColor = _prefs.getInt('primary_color') ?? Colors.blue.value;
    _primary = Color(primaryColor);

    int secondaryColor = _prefs.getInt('secondary_color') ?? Colors.red.value;
    _secondary = Color(secondaryColor);
    notifyListeners();
  }

  Color get primary => _primary;
  Color get secondary => _secondary;
  ThemeData get themeData => _themeData;
  String get themeName => _themeName;
  bool get isSkyTheme => _themeData == NoxioThemes().skyTheme;

  void setPrimaryColor(Color color) {
    _primary = color;
    _prefs.setInt("primary_color", color.value);
    notifyListeners();
  }

  void setSecondaryColor(Color color) {
    _secondary = color;
    _prefs.setInt("secondary_color", color.value);
    notifyListeners();
  }

  void setTheme(String theme) {
    _prefs.setString("theme", theme);
    _themeName = theme;
    _themeData = NoxioThemes().map[theme];
    notifyListeners();
  }
}
