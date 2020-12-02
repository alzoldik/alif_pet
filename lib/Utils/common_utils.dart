import 'dart:io';

import 'package:alif_pet/language/app_localization.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class CommonUtils {
  static String getLanguage(BuildContext context) {
    if (AppLocalizations.of(context).locale.languageCode == "ar") {
      return "arabic";
    }
    return "english";
  }

  static String translate(BuildContext context, String key) {
    return AppLocalizations.of(context).translate(key);
  }

  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return true;
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.mobile) {
    //   print("Connected to Mobile Network");
    //   return true;
    // } else if (connectivityResult == ConnectivityResult.wifi) {
    //   print("Connected to WiFi");
    //   return true;
    // } else {
    //   print("Unable to connect. Please Check Internet Connection");
    //   return false;
    // }
  }

  // ignore: non_constant_identifier_names
  static String capitalize(String) {
    return ('${String[0].toUpperCase()}${String.substring(1)}');
  }

  static MaterialColor getPrimaryColor() {
    Map<int, Color> color = {
      50: Color.fromRGBO(57, 46, 54, .1),
      100: Color.fromRGBO(57, 46, 54, .2),
      200: Color.fromRGBO(57, 46, 54, .3),
      300: Color.fromRGBO(57, 46, 54, .4),
      400: Color.fromRGBO(57, 46, 54, .5),
      500: Color.fromRGBO(57, 46, 54, .6),
      600: Color.fromRGBO(57, 46, 54, .7),
      700: Color.fromRGBO(57, 46, 54, .8),
      800: Color.fromRGBO(57, 46, 54, .9),
      900: Color.fromRGBO(57, 46, 54, 1),
    };
    MaterialColor getColor = MaterialColor(0xFF392e36, color);
    return getColor;
  }

  static bool isValidEmail(String email) {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }
}
