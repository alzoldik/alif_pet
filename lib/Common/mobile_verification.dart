import 'package:alif_pet/Apis/common_apis.dart';
import 'package:alif_pet/Common/login.dart';
import 'package:alif_pet/Utils/string_utils.dart';
import 'package:alif_pet/Utils/toast_utils.dart';
import 'package:alif_pet/models/verificatedModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../Utils/common_utils.dart';
import '../Utils/font_utils.dart';
import '../Utils/image_utils.dart';
import '../Utils/my_colors.dart';
import '../Utils/screen_config.dart';
import '../Utils/screen_util.dart';
import '../language/app_localization.dart';
import 'app_background.dart';

class MobileVerification extends StatefulWidget {
  final VerificationModel verificationModel;
  final bool fromLogin;
  const MobileVerification({Key key, this.verificationModel, this.fromLogin})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return MobileVerificationState();
  }
}

class MobileVerificationState extends State<MobileVerification> {
  bool isCodeEntered = false;
  final codeController = TextEditingController();
  bool isVerifying = false;
  @override
  void initState() {
    CommonApis().getMobileCode(
        {"mobile": widget.verificationModel.numnber}, true).then((value) {
      if (value is String) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    codeController.addListener(() {
      if (codeController.text.length > 4) {
        isCodeEntered = true;
      } else {
        isCodeEntered = false;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            AppBackground(),
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 7 * SizeConfig.heightMultiplier),
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
                  margin: EdgeInsets.only(top: 3 * SizeConfig.heightMultiplier),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("mobile_verification"),
                    style: TextStyle(
                        fontFamily: FontUtils.ceraProMedium,
                        fontSize: 3.5 * SizeConfig.textMultiplier,
                        color: MyColors.primaryColor),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: 3 * SizeConfig.heightMultiplier,
                      right: 3 * SizeConfig.widthMultiplier,
                      left: 3 * SizeConfig.widthMultiplier),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("mobile_verification_text"),
                    style: TextStyle(
                        fontFamily: FontUtils.ceraProRegular,
                        fontSize: 2.6 * SizeConfig.textMultiplier,
                        color: MyColors.primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: 1.5 * SizeConfig.heightMultiplier,
                        right: 13 * SizeConfig.widthMultiplier,
                        left: 13 * SizeConfig.widthMultiplier),
                    child: PinCodeTextField(
                      controller: codeController,
                      length: 5,
                      obsecureText: false,
                      animationType: AnimationType.fade,
                      shape: PinCodeFieldShape.box,
                      animationDuration: Duration(milliseconds: 300),
                      fieldHeight:
                          (ScreenUtil.getInstance().width.toDouble() / 5) -
                              7 * SizeConfig.widthMultiplier,
                      textInputType: TextInputType.number,
                      fieldWidth:
                          (ScreenUtil.getInstance().width.toDouble() / 5) -
                              7 * SizeConfig.widthMultiplier,
                      onChanged: (value) {},
                      borderWidth: .1 * SizeConfig.heightMultiplier,
                      activeColor: MyColors.dark_red,
                      inactiveColor: MyColors.dark_red,
                      selectedColor: MyColors.dark_red,
                      disabledColor: MyColors.dark_red,
                      textStyle: TextStyle(
                          fontSize: 3.9 * SizeConfig.textMultiplier,
                          fontFamily: "klavika-light",
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )),
                Container(
                  margin: EdgeInsets.only(
                      right: 6.5 * SizeConfig.widthMultiplier,
                      left: 6.5 * SizeConfig.widthMultiplier,
                      top: 5 * SizeConfig.heightMultiplier),
                  child: MaterialButton(
                    onPressed: isVerifying || codeController.text.length < 5
                        ? null
                        : () {
                            if (codeController.text.length == 5) {
                              verifyMobile(widget.verificationModel.numnber,
                                  codeController.text);
                            } else {}
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(AppLocalizations.of(context).translate("next"),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 2.9 * SizeConfig.textMultiplier,
                                fontFamily: FontUtils.ceraProRegular)),
                        Padding(
                          padding: CommonUtils.getLanguage(context) == "english"
                              ? EdgeInsets.only(
                                  left: 2 * SizeConfig.widthMultiplier)
                              : EdgeInsets.only(
                                  right: 2 * SizeConfig.widthMultiplier),
                          child: RotationTransition(
                              turns:
                                  CommonUtils.getLanguage(context) == "english"
                                      ? AlwaysStoppedAnimation(0)
                                      : AlwaysStoppedAnimation(180 / 360),
                              child: Image(
                                image: AssetImage(ImageUtils.nextArrow),
                                width: 7 * SizeConfig.imageSizeMultiplier,
                                height: 7 * SizeConfig.imageSizeMultiplier,
                                color: MyColors.red,
                              )),
                        )
                      ],
                    ),
                    //   onPressed: isCodeEntered? verifyMobile : null,
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
              ],
            ),
            //   isLoading?Loading():Container()
          ],
        ),
      ),
    );
  }

  void verifyMobile(var number, var code) {
    CommonUtils.checkInternet().then((isInternet) {
      if (isInternet) {
        Map<String, Object> data = new Map();
        data.putIfAbsent("mobile", () => number);
        data.putIfAbsent("verification_code", () => code);
        isVerifying = true;
        setState(() {});
        CommonApis().verifyMobile(data, context).then((result) {
          if (result is String) {
            ToastUtils.showCustomToast(
                context, result, Colors.white, MyColors.primaryColor);
            if (mounted) {
              setState(() {
                isVerifying = false;
              });
            }
          } else if (result is bool && result) {
            if (mounted) {
              setState(() {
                isVerifying = false;
              });
            }
            //ToastUtils.showCustomToast(context, result , Colors.white , MyColors.primaryColor);
            if (widget.fromLogin != null && widget.fromLogin) {
              Navigator.pop(context);
            } else {
              if (widget.verificationModel.role == 2) {
                Navigator.pushAndRemoveUntil(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: Login()),
                    (Route<dynamic> route) => false);
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: Login()),
                    (Route<dynamic> route) => false);
              }
            }
          }
        });
      } else {
        ToastUtils.showCustomToast(context, StringUtils.noInternet,
            Colors.white, MyColors.primaryColor);
      }
    });
  }
}
