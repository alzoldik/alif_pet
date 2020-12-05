import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Apis/common_apis.dart';
import 'package:alif_pet/Common/about_the_app.dart';
import 'package:alif_pet/Common/forgot_password.dart';
import 'package:alif_pet/Common/mobile_verification.dart';
import 'package:alif_pet/Common/register_as.dart';
import 'package:alif_pet/Services/user_service.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/Utils/string_utils.dart';
import 'package:alif_pet/Utils/toast_utils.dart';
import 'package:alif_pet/Utils/userData.dart';
import 'package:alif_pet/language/app_localization.dart';
import 'package:alif_pet/models/login_response.dart';
import 'package:alif_pet/models/verificatedModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../Apis/api_utils.dart';
import '../Apis/common_apis.dart';
import '../Client/client_main.dart';
import '../Doctor/doctor_main.dart';
import '../language/app_localization.dart';
import 'app_background.dart';
import 'app_language.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  bool isLoggingIn = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final emailOrMobileEtController = TextEditingController();
  final passwordEtController = TextEditingController();
  AppLanguage appLanguage;
  UserData userData;
  UserService userService;
  @override
  void initState() {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white, animate: true);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    super.initState();
  }

  @override
  void dispose() {
    emailOrMobileEtController.dispose();
    passwordEtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appLanguage = Provider.of<AppLanguage>(context);
    userData = Provider.of<UserData>(context, listen: false);
    userService = Provider.of<UserService>(context, listen: false);
    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              AppBackground(),
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(top: 7 * SizeConfig.heightMultiplier),
                      alignment: Alignment.topCenter,
                      child: Hero(
                        tag: "logo",
                        child: Material(
                          color: Colors.transparent,
                          child: Image.asset(
                            ImageUtils.logo,
                            width: 22 * SizeConfig.imageSizeMultiplier,
                            height: 22 * SizeConfig.imageSizeMultiplier,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              top: 3 * SizeConfig.heightMultiplier,
                              left: 6.5 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              top: 3 * SizeConfig.heightMultiplier,
                              right: 6.5 * SizeConfig.widthMultiplier),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate("email_or_mobile"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProThin,
                            fontSize: 2.6 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: 6 * SizeConfig.heightMultiplier,
                      margin: EdgeInsets.only(
                          top: 1 * SizeConfig.heightMultiplier,
                          left: 6.5 * SizeConfig.widthMultiplier,
                          right: 6.5 * SizeConfig.widthMultiplier),
                      child: TextFormField(
                        controller: emailOrMobileEtController,
                        cursorColor: MyColors.primaryColor,
                        textAlign: TextAlign.start,
                        autofocus: false,
                        style: TextStyle(
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          fontFamily: FontUtils.ceraProMedium,
                          color: MyColors.primaryColor,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 1.0 * SizeConfig.heightMultiplier,
                              horizontal: 3.0 * SizeConfig.widthMultiplier),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyColors.red),
                            borderRadius: BorderRadius.circular(
                                2.8 * SizeConfig.imageSizeMultiplier),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyColors.red),
                            borderRadius: BorderRadius.circular(
                                2.8 * SizeConfig.imageSizeMultiplier),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              top: 3 * SizeConfig.heightMultiplier,
                              left: 6.5 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              top: 3 * SizeConfig.heightMultiplier,
                              right: 6.5 * SizeConfig.widthMultiplier),
                      child: Text(
                        AppLocalizations.of(context).translate("password"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProThin,
                            fontSize: 2.6 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: 6 * SizeConfig.heightMultiplier,
                      margin: EdgeInsets.only(
                          top: 1 * SizeConfig.heightMultiplier,
                          left: 6.5 * SizeConfig.widthMultiplier,
                          right: 6.5 * SizeConfig.widthMultiplier),
                      child: TextFormField(
                        controller: passwordEtController,
                        obscureText: true,
                        cursorColor: MyColors.primaryColor,
                        textAlign: TextAlign.start,
                        autofocus: false,
                        style: TextStyle(
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          fontFamily: FontUtils.ceraProMedium,
                          color: MyColors.primaryColor,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 1.0 * SizeConfig.heightMultiplier,
                              horizontal: 3.0 * SizeConfig.widthMultiplier),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyColors.red),
                            borderRadius: BorderRadius.circular(
                                2.8 * SizeConfig.imageSizeMultiplier),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyColors.red),
                            borderRadius: BorderRadius.circular(
                                2.8 * SizeConfig.imageSizeMultiplier),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          right: 6.5 * SizeConfig.widthMultiplier,
                          left: 6.5 * SizeConfig.widthMultiplier,
                          top: 5 * SizeConfig.heightMultiplier),
                      child: MaterialButton(
                        child: Text(
                            AppLocalizations.of(context).translate("login"),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 2.9 * SizeConfig.textMultiplier,
                                fontFamily: FontUtils.ceraProRegular)),
                        onPressed: isLoggingIn
                            ? null
                            : () {
                                doLogin(context);
                              },
                        height: 6 * SizeConfig.heightMultiplier,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                2.8 * SizeConfig.imageSizeMultiplier))),
                        color: MyColors.primaryColor,
                        elevation: 0.0,
                        highlightElevation: 0.0,
                        disabledColor: MyColors.primaryColor.withOpacity(.8),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: ForgotPassword()));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            top: 3 * SizeConfig.heightMultiplier),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate("forget_password"),
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProLight,
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              color: MyColors.blue,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 3 * SizeConfig.heightMultiplier,
                          right: 1.5 * SizeConfig.heightMultiplier,
                          left: 1.5 * SizeConfig.heightMultiplier),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: 1,
                              width: ScreenUtil.getInstance().width.toDouble(),
                              color: Colors.grey.withOpacity(.4),
                            ),
                          ),

                          Expanded(
                            flex: 4,
                            child: Container(
                              height: 1,
                              width: ScreenUtil.getInstance().width.toDouble(),
                              color: Colors.grey.withOpacity(.4),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: GestureDetector(
                              onTap: doFacebookSignIn,
                              child: Container(
                                alignment: CommonUtils.getLanguage(context) ==
                                        "english"
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Image.asset(
                                  ImageUtils.facebookIcon,
                                  width: 14 * SizeConfig.imageSizeMultiplier,
                                  height: 14 * SizeConfig.imageSizeMultiplier,
                                ),
                              ),
                            ),
                          ),
                          Expanded(flex: 2, child: Container()),
                          Expanded(
                            flex: 4,
                            child: GestureDetector(
                              onTap: () async {
                                try {
                                  GoogleSignInAccount myaccount =
                                      await _googleSignIn.signIn();
                                  if (myaccount != null) {
                                    myaccount.authentication
                                        .then((value) async {
                                      print(
                                          "ACCESS_TOKEN : ${value.accessToken}");
                                      dynamic response = await CommonApis()
                                          .logInWithGmail(
                                              {"token": value.accessToken},
                                              CommonUtils.getLanguage(
                                                      context) ==
                                                  "english");
                                      String fullToken =
                                          "Bearer ${response['token']}";
                                      ApiUtils.headerWithToken.update(
                                          "Authorization",
                                          (value) => fullToken);
                                      await userData.save(fullToken, "client");
                                      await _googleSignIn.signOut();
                                      await userService.getProfile();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child: ClientMain()),
                                          (Route<dynamic> route) => false);
                                    });
                                  }
                                } on PlatformException catch (e) {
                                  print(e.toString());
                                }
                              },
                              child: Container(
                                  alignment: CommonUtils.getLanguage(context) ==
                                          "english"
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Image.asset(
                                    ImageUtils.googleIcon,
                                    width: 14 * SizeConfig.imageSizeMultiplier,
                                    height: 14 * SizeConfig.imageSizeMultiplier,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            top: 2.5 * SizeConfig.heightMultiplier),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)
                                  .translate("dont_have_account"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: FontUtils.ceraProThin,
                                  fontSize: 2.4 * SizeConfig.textMultiplier,
                                  color: MyColors.primaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: new GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: RegisterAs()));
                                },
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate("register_now"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FontUtils.ceraProLight,
                                    fontSize: 2.4 * SizeConfig.textMultiplier,
                                    color: MyColors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: AboutTheApp()));
                      },
                      child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              top: 2.5 * SizeConfig.heightMultiplier,
                              bottom: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.help,
                                size: 6 * SizeConfig.imageSizeMultiplier,
                                color: MyColors.primaryColor,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate("about_app"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: FontUtils.ceraProRegular,
                                      fontSize: 2.4 * SizeConfig.textMultiplier,
                                      color: MyColors.primaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (CommonUtils.getLanguage(context) == "english") {
                    appLanguage.changeLanguage(Locale("ar"));
                  } else {
                    appLanguage.changeLanguage(Locale("en"));
                  }
                },
                child: Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(
                      left: 3 * SizeConfig.widthMultiplier,
                      top: 1 * SizeConfig.heightMultiplier),
                  child: Text(
                    AppLocalizations.of(context).translate("language"),
                    style: TextStyle(
                        fontFamily: FontUtils.ceraProMedium,
                        fontSize: 2.7 * SizeConfig.textMultiplier,
                        color: MyColors.primaryColor),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void doLogin(BuildContext context) {
    String fullToken;
    String userType;
    CommonUtils.checkInternet().then((isInternet) {
      if (isInternet) {
        if (emailOrMobileEtController.text.length > 0) {
          if (passwordEtController.text.length > 0) {
            isLoggingIn = true;
            setState(() {});
            CommonApis().login({
              "client_secret": ApiUtils.clientSecret,
              "username": emailOrMobileEtController.text,
              "password": passwordEtController.text
            }).then((response) {
              if (response is String) {
                ToastUtils.showCustomToast(
                    context, response, Colors.white, MyColors.primaryColor);
              } else if (response is! LoginResponse) {
                isLoggingIn = false;
                setState(() {});
                VerificationModel verificationModel = new VerificationModel();
                if (response['error']['show'] == null) {
                  ToastUtils.showCustomToast(
                      context,
                      CommonUtils.getLanguage(context) == "english"
                          ? response['error']['en']
                          : response['error']['ar'],
                      Colors.white,
                      MyColors.primaryColor);
                  return;
                }
                if (response['error']['show'] == "mobile_verify") {
                  verificationModel.role = null;
                  verificationModel.numnber = response['error']['mobile'];
                  verificationModel.email = emailOrMobileEtController.text;
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: MobileVerification(
                            verificationModel: verificationModel,
                            fromLogin: true,
                          )));
                } else {
                  verificationModel.role = null;
                  verificationModel.numnber = emailOrMobileEtController.text;
                  verificationModel.email = response['error']['email'];
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: MobileVerification(
                            verificationModel: verificationModel,
                            fromLogin: true,
                          )));
                }
                ToastUtils.showCustomToast(
                    context,
                    CommonUtils.getLanguage(context) == "english"
                        ? response['error']['en']
                        : response['error']['ar'],
                    Colors.white,
                    MyColors.primaryColor);
              } else {
                LoginResponse loginResponse = response;
                fullToken = "Bearer ${loginResponse.token}";
                ApiUtils.headerWithToken
                    .update("Authorization", (value) => fullToken);
                CommonApis()
                    .getUserRole(CommonUtils.getLanguage(context) == "english")
                    .then((response) async {
                  List result = response;
                  if (result[0]) {
                    userType = result[1];
                    userData.save(fullToken, userType);
                    await userService.getProfile();
                    isLoggingIn = false;
                    setState(() {});
                    print("Token : $fullToken role : $userType");
                    if (userType == "client") {
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: ClientMain()),
                          (Route<dynamic> route) => false);
                    } else {
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: DoctorMain()),
                          (Route<dynamic> route) => false);
                    }
                  } else {
                    isLoggingIn = false;
                    setState(() {});
                  }
                });
              }
            });
          } else {
            ToastUtils.showCustomToast(context, "Enter Passowrd!", Colors.white,
                MyColors.primaryColor);
          }
        } else {
          ToastUtils.showCustomToast(context, "Enter Email or Phone No.!",
              Colors.white, MyColors.primaryColor);
        }
      } else {
        ToastUtils.showCustomToast(context, StringUtils.noInternet,
            Colors.white, MyColors.primaryColor);
      }
    });
  }

  void hitFacebookApi(String token) {
    CommonApis().logInWithFB({"token": "$token"},
        CommonUtils.getLanguage(context) == "english").then((value) async {
      if (value is Map) {
        String fullToken = "Bearer ${value['token']}";
        ApiUtils.headerWithToken.update("Authorization", (value) => fullToken);
        await userData.save(fullToken, "client");
        await userService.getProfile();
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(type: PageTransitionType.fade, child: ClientMain()),
            (Route<dynamic> route) => false);
      } else {
        ToastUtils.showCustomToast(
            context, value, Colors.white, MyColors.primaryColor);
      }
    });
  }

  void doFacebookSignIn() async {
    final facebookLogin = FacebookLogin();
    //   facebookLogin.logOut();
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        //  hitFacebookApi(result.accessToken.token);
        hitFacebookApi(result.accessToken.token);
        await facebookLogin.logOut();
        break;
      case FacebookLoginStatus.cancelledByUser:
        ToastUtils.showCustomToast(
            context, "cancelled", Colors.white, MyColors.primaryColor);
        break;
      case FacebookLoginStatus.error:
        ToastUtils.showCustomToast(
            context, result.errorMessage, Colors.white, MyColors.primaryColor);
        break;
    }
  }

  // ignore: unused_element
  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }
}
