import 'package:alif_pet/Apis/common_apis.dart';
import 'package:alif_pet/Common/app_background.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/toast_utils.dart';
import 'package:alif_pet/language/app_localization.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String sendCodeBy = "email";
  bool isSendingCode = false;
  bool isResetingPassword = false;
  bool isCodeSent = false;
  CommonApis commonApis = CommonApis();
  final emailOrMobileEtController = TextEditingController();
  final newPasswordController = TextEditingController();
  final resetCodeController = TextEditingController();
  void updateValue(String value) {
    setState(() {
      sendCodeBy = value;
    });
  }

  void sendCode() async {
    Map<String, dynamic> data = Map();
    if (sendCodeBy == "email") {
      data.putIfAbsent("email", () => emailOrMobileEtController.text);
    } else {
      data.putIfAbsent("mobile", () => emailOrMobileEtController.text);
    }
    isSendingCode = true;
    setState(() {});
    dynamic response = await commonApis.sendCodeToResetPassword(
        CommonUtils.getLanguage(context) == "english", data);
    if (response is Map) {
      isSendingCode = false;
      isCodeSent = true;
      setState(() {});
      ToastUtils.showCustomToast(
          context, response['message'], Colors.white, MyColors.primaryColor);
    } else {
      isSendingCode = false;
      setState(() {});
      ToastUtils.showCustomToast(
          context, response, Colors.white, MyColors.primaryColor);
    }
  }

  void resetPassword() async {
    if (resetCodeController.text.length > 0) {
      if (newPasswordController.text.length > 0) {
        isResetingPassword = true;
        setState(() {});
        Map<String, dynamic> data = Map();
        if (sendCodeBy == "email") {
          data.putIfAbsent("email", () => emailOrMobileEtController.text);
        } else {
          data.putIfAbsent("mobile", () => emailOrMobileEtController.text);
        }
        data.putIfAbsent("reset_code", () => resetCodeController.text);
        data.putIfAbsent("password", () => newPasswordController.text);
        dynamic response = await commonApis.resetPassword(
            CommonUtils.getLanguage(context) == "english", data);
        if (response is Map) {
          isResetingPassword = false;
          isCodeSent = true;
          setState(() {});
          ToastUtils.showCustomToast(context, response['message'], Colors.white,
              MyColors.primaryColor);
          Navigator.pop(context);
        } else {
          isResetingPassword = false;
          setState(() {});
          ToastUtils.showCustomToast(
              context, response, Colors.white, MyColors.primaryColor);
        }
      } else {
        ToastUtils.showCustomToast(context, "Please enter New Password",
            Colors.white, MyColors.primaryColor);
      }
    } else {
      ToastUtils.showCustomToast(
          context, "Please enter code", Colors.white, MyColors.primaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
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
                    alignment: Alignment.center,
                    margin:
                        EdgeInsets.only(top: 3 * SizeConfig.heightMultiplier),
                    child: Text(
                      AppLocalizations.of(context).translate("reset_password"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProMedium,
                          fontSize: 3.5 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),
                  if (!isCodeSent) beforeCodeSent(),
                  if (isCodeSent) afterCodeSent()
                ],
              ),
            ),
            Align(
              alignment: CommonUtils.getLanguage(context) == "english"
                  ? Alignment.topLeft
                  : Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.keyboard_backspace,
                  color: MyColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget beforeCodeSent() {
    return Column(
      children: <Widget>[
        Text(
          AppLocalizations.of(context).translate("send_code_using"),
          style: TextStyle(
              fontFamily: FontUtils.ceraProMedium,
              fontSize: 2.5 * SizeConfig.textMultiplier,
              color: MyColors.primaryColor),
        ),
        SizedBox(
          height: 2 * SizeConfig.heightMultiplier,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
              value: "email",
              groupValue: sendCodeBy,
              onChanged: updateValue,
              activeColor: MyColors.primaryColor,
            ),
            Text(
              AppLocalizations.of(context).translate("email"),
              style: TextStyle(
                  fontFamily: FontUtils.ceraProMedium,
                  fontSize: 2.5 * SizeConfig.textMultiplier,
                  color: MyColors.primaryColor),
            ),
            SizedBox(
              width: 4 * SizeConfig.widthMultiplier,
            ),
            Radio(
              value: "mobile",
              groupValue: sendCodeBy,
              onChanged: updateValue,
              activeColor: MyColors.primaryColor,
            ),
            Text(
              AppLocalizations.of(context).translate("mobile"),
              style: TextStyle(
                  fontFamily: FontUtils.ceraProMedium,
                  fontSize: 2.5 * SizeConfig.textMultiplier,
                  color: MyColors.primaryColor),
            ),
          ],
        ),
        SizedBox(
          height: 2 * SizeConfig.heightMultiplier,
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
              hintText: AppLocalizations.of(context).translate("enter_here"),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 1.0 * SizeConfig.heightMultiplier,
                  horizontal: 3.0 * SizeConfig.widthMultiplier),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColors.red),
                borderRadius:
                    BorderRadius.circular(2.8 * SizeConfig.imageSizeMultiplier),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColors.red),
                borderRadius:
                    BorderRadius.circular(2.8 * SizeConfig.imageSizeMultiplier),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              right: 6.5 * SizeConfig.widthMultiplier,
              left: 6.5 * SizeConfig.widthMultiplier,
              top: 2 * SizeConfig.heightMultiplier),
          child: MaterialButton(
            child: Text(AppLocalizations.of(context).translate("send_code"),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 2.9 * SizeConfig.textMultiplier,
                    fontFamily: FontUtils.ceraProRegular)),
            onPressed: isSendingCode ? null : sendCode,
            height: 6 * SizeConfig.heightMultiplier,
            minWidth: double.infinity,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(2.8 * SizeConfig.imageSizeMultiplier))),
            color: MyColors.primaryColor,
            elevation: 0.0,
            highlightElevation: 0.0,
            disabledColor: MyColors.primaryColor.withOpacity(.8),
          ),
        ),
      ],
    );
  }

  Widget afterCodeSent() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerRight,
          height: 6 * SizeConfig.heightMultiplier,
          margin: EdgeInsets.only(
              top: 1 * SizeConfig.heightMultiplier,
              left: 6.5 * SizeConfig.widthMultiplier,
              right: 6.5 * SizeConfig.widthMultiplier),
          child: TextFormField(
            controller: resetCodeController,
            cursorColor: MyColors.primaryColor,
            textAlign: TextAlign.start,
            autofocus: false,
            style: TextStyle(
              fontSize: 2.2 * SizeConfig.textMultiplier,
              fontFamily: FontUtils.ceraProMedium,
              color: MyColors.primaryColor,
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)
                  .translate("enter_reset_code_here"),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 1.0 * SizeConfig.heightMultiplier,
                  horizontal: 3.0 * SizeConfig.widthMultiplier),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColors.red),
                borderRadius:
                    BorderRadius.circular(2.8 * SizeConfig.imageSizeMultiplier),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColors.red),
                borderRadius:
                    BorderRadius.circular(2.8 * SizeConfig.imageSizeMultiplier),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 2 * SizeConfig.heightMultiplier,
        ),
        Container(
          alignment: Alignment.centerRight,
          height: 6 * SizeConfig.heightMultiplier,
          margin: EdgeInsets.only(
              top: 1 * SizeConfig.heightMultiplier,
              left: 6.5 * SizeConfig.widthMultiplier,
              right: 6.5 * SizeConfig.widthMultiplier),
          child: TextFormField(
            obscureText: true,
            controller: newPasswordController,
            cursorColor: MyColors.primaryColor,
            textAlign: TextAlign.start,
            autofocus: false,
            style: TextStyle(
              fontSize: 2.2 * SizeConfig.textMultiplier,
              fontFamily: FontUtils.ceraProMedium,
              color: MyColors.primaryColor,
            ),
            decoration: InputDecoration(
              hintText:
                  AppLocalizations.of(context).translate("enter_new_password"),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 1.0 * SizeConfig.heightMultiplier,
                  horizontal: 3.0 * SizeConfig.widthMultiplier),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColors.red),
                borderRadius:
                    BorderRadius.circular(2.8 * SizeConfig.imageSizeMultiplier),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColors.red),
                borderRadius:
                    BorderRadius.circular(2.8 * SizeConfig.imageSizeMultiplier),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              right: 6.5 * SizeConfig.widthMultiplier,
              left: 6.5 * SizeConfig.widthMultiplier,
              top: 2 * SizeConfig.heightMultiplier),
          child: MaterialButton(
            child: Text(AppLocalizations.of(context).translate("reset_pass"),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 2.9 * SizeConfig.textMultiplier,
                    fontFamily: FontUtils.ceraProRegular)),
            onPressed: isResetingPassword ? null : resetPassword,
            height: 6 * SizeConfig.heightMultiplier,
            minWidth: double.infinity,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(2.8 * SizeConfig.imageSizeMultiplier))),
            color: MyColors.primaryColor,
            elevation: 0.0,
            highlightElevation: 0.0,
            disabledColor: MyColors.primaryColor.withOpacity(.8),
          ),
        ),
      ],
    );
  }
}
