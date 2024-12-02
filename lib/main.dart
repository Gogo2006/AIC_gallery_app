import 'package:aic_gallery_app/pages/home_page.dart';
import 'package:aic_gallery_app/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<MyAppState>(context).currTheme,
      home: const HomePage(),
    );
  }
}

class MyAppState extends ChangeNotifier {
  ThemeData _currTheme = lightMode;

  ThemeData get currTheme =>_currTheme;

  set currTheme(ThemeData themeData) {
    _currTheme = themeData;
    notifyListeners();
  }

  updateTheme() async {
    try{
      final themePref = await SharedPreferences.getInstance();

      if (themePref.getBool("isLightMode") ?? true) {
        currTheme = lightMode;
      }
      else {
        currTheme = darkMode;
      }

      notifyListeners();
    }
    catch(e) {
      print(e);
    }
  }

  switchTheme() async {
    final themePref = await SharedPreferences.getInstance();

    if (themePref.getBool("isLightMode") ?? true) {
      await themePref.setBool("isLightMode", false);
    }
    else {
      await themePref.setBool("isLightMode", true);
    }

    updateTheme();

    // if (_currTheme == lightMode) {
    //   currTheme = darkMode;
    // }
    // else {
    //   currTheme = lightMode;
    // }
    //
    // notifyListeners();
  }

  // changeTheme() async{
  //   final themePref = await SharedPreferences.getInstance();
  //
  //   if (themePref.getBool("isLightMode") == null) {
  //     themePref.setBool("isLightMode", true);
  //   }
  //   else if (themePref.getBool("isLightMode") == true) {
  //     themePref.setBool("isLightMode", false);
  //   }
  //   else if (themePref.getBool("isLightMode") == false) {
  //     themePref.setBool("isLightMode", true);
  //   }
  // }

  String shrtndLine(String? line) {
    if (line == null) {
      return "Loading...";
    }

    if (!line.contains('(')) {
      if (line.length > 15) {
        return "${line.substring(0, 15)}...";
      }
      return line;
    }

    if (line.substring(0, line.indexOf('(') - 1).length > 15) {
      return "${line.substring(0, 15)}...";
    }
    return line.substring(0, line.indexOf('(') - 1);
  }

  String shrtndDate(String? date) {
    if (date == null) {
      return "Loading...";
    }

    if (date.length > 4) {
      return "${date.substring(0, 4)}...";
    }
    return date;
  }
}