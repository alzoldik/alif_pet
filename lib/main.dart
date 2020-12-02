import 'package:alif_pet/Common/splash_screen.dart';
import 'package:alif_pet/Services/user_service.dart';
import 'package:alif_pet/Utils/userData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Common/app_language.dart';
import 'Utils/screen_config.dart';
import 'Utils/screen_util.dart';
import 'language/app_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  UserData userData = UserData();
  final prefs = await SharedPreferences.getInstance();
  await userData.readUserData(prefs);
  await appLanguage.fetchLocale();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<AppLanguage>(
            create: (BuildContext context) => appLanguage),
        ChangeNotifierProvider<UserData>(
            create: (BuildContext context) => userData),
        ChangeNotifierProvider<UserService>(create: (_) => UserService()),
      ],
      child: Consumer<AppLanguage>(builder: (context, languageModel, child) {
        return Consumer<UserData>(builder: (context, model, child) {
          return MaterialApp(
            locale: languageModel.appLocal,
            supportedLocales: [
              Locale('en', 'US'),
              Locale('ar', ''),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            theme: ThemeData(
                accentColor: Colors.white,
                focusColor: Colors.white,
                cursorColor: Colors.white,
                primaryColor: Colors.white),
            home: MyApp(),
            debugShowCheckedModeBanner: false,
          );
        });
      }),
    ));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(
        width: MediaQuery.of(context).size.width.round(),
        height: MediaQuery.of(context).size.height.round(),
        allowFontScaling: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return Splash();
          },
        );
      },
    );
  }
}
