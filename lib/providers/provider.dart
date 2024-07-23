import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UiProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;
  //luu thay dôi theme
  late SharedPreferences storage;

  final darkTheme = ThemeData(
      primaryColor: Colors.black12,
      brightness: Brightness.dark,
      primaryColorDark: const Color.fromARGB(31, 82, 194, 241));
  final lightTheme = ThemeData(
    primaryColor: Colors.transparent,
    brightness: Brightness.light,
    primaryColorLight: Colors.transparent,
  );

  changeTheme() {
    _isDark = !isDark;
    //Save the value
    storage.setBool("isDark", _isDark);
    notifyListeners();
  }

  init() async {
    storage = await SharedPreferences.getInstance();
    _isDark = storage.getBool("IsDark") ?? false;
    notifyListeners();
  }
}