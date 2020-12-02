import 'dart:io';

import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Apis/common_apis.dart';
import 'package:alif_pet/Common/my_loader.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/string_utils.dart';
import 'package:alif_pet/Utils/toast_utils.dart';
import 'package:alif_pet/language/app_localization.dart';
import 'package:alif_pet/models/update_profile.dart';
import 'package:alif_pet/models/profile.dart';
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as myPath;

class ClientProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClientProfileState();
  }
}

class ClientProfileState extends State<ClientProfile> {
  bool isLoading = true;
  bool isInternet = true;
  bool isEnglish = true;
  bool isUpdating = false;
  bool isEditEmail = false;
  bool isEditNumber = false;
  bool isEditAddress = false;
  Profile profile;
  File profilePic;
  final editEmailController = TextEditingController();
  final editNumberController = TextEditingController();
  final editAddressController = TextEditingController();

  @override
  void initState() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        CommonApis().getProfile().then((result) {
          if (result is String) {
            //ToastUtils.showCustomToast(context, result, Colors.white , MyColors.primaryColor);
          } else {
            profile = result;
            editEmailController.text = profile.email;
            editNumberController.text = profile.mobile;
            editAddressController.text = profile.address;
            isLoading = false;
            if (mounted) {
              setState(() {});
            }
          }
        });
      } else {
        if (mounted) {
          setState(() {
            isInternet = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    editEmailController.dispose();
    editNumberController.dispose();
    editAddressController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    isEnglish = CommonUtils.getLanguage(context) == "english";
    super.didChangeDependencies();
  }

  void updateProfile() {
    CommonUtils.checkInternet().then((value) async {
      if (value) {
        isUpdating = true;
        if (mounted) {
          setState(() {});
        }
        CommonApis()
            .updateProfile(
                FormData.fromMap({
                  "email": editEmailController.text.length > 0
                      ? editEmailController.text
                      : "",
                  "mobile": editNumberController.text.length > 0
                      ? editNumberController.text
                      : "",
                  "address": editAddressController.text.length > 0
                      ? editAddressController.text
                      : "",
                  "photo": profilePic == null
                      ? profile.photo
                      : await MultipartFile.fromFile(profilePic.path,
                          filename: myPath.basename(profilePic.path))
                }),
                isEnglish)
            .then((value) {
          if (value is String) {
            ToastUtils.showCustomToast(
                context, value, Colors.white, MyColors.primaryColor);
          } else {
            isUpdating = false;
            isEditAddress = false;
            isEditEmail = false;
            isEditNumber = false;
            Update_profile response = value;
            ToastUtils.showCustomToast(
                context,
                isEnglish ? response.success.en : response.success.ar,
                Colors.white,
                MyColors.primaryColor);
            if (mounted) {
              setState(() {});
            }
          }
        });
      } else {
        ToastUtils.showCustomToast(context, StringUtils.noInternet,
            Colors.white, MyColors.primaryColor);
      }
    });
  }

  void openGalleryForPfp() async {
    File profilePicToChange =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    if (profilePicToChange != null) {
      setState(() {
        profilePic = profilePicToChange;
      });
    }
  }

  void onEditEmailTap() {
    if (isEditEmail) {
      isEditEmail = false;
    } else {
      isEditEmail = true;
    }
    setState(() {});
  }

  void onEditNumberTap() {
    if (isEditNumber) {
      isEditNumber = false;
    } else {
      isEditNumber = true;
    }
    setState(() {});
  }

  void onEditAddressTap() {
    if (isEditAddress) {
      isEditAddress = false;
    } else {
      isEditAddress = true;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        children: <Widget>[
          !isLoading
              ? SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: 24 * SizeConfig.imageSizeMultiplier,
                                  width: 24 * SizeConfig.imageSizeMultiplier,
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height:
                                            23 * SizeConfig.imageSizeMultiplier,
                                        width:
                                            23 * SizeConfig.imageSizeMultiplier,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(.5),
                                                  blurRadius: 3.5 *
                                                      SizeConfig
                                                          .imageSizeMultiplier,
                                                  spreadRadius: 0.0,
                                                  offset: Offset(2, 6.0)),
                                            ],
                                            color: Colors.white),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          child: profilePic == null
                                              ? profile.photo == null
                                                  ? Image.asset(
                                                      ImageUtils.doctorIcon,
                                                      fit: BoxFit.contain,
                                                    )
                                                  : Image.network(
                                                      ApiUtils.BaseApiUrlMain +
                                                          profile.photo,
                                                      fit: BoxFit.contain,
                                                    )
                                              : Image.file(
                                                  profilePic,
                                                  fit: BoxFit.contain,
                                                ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: openGalleryForPfp,
                                          child: Container(
                                            height: 8 *
                                                SizeConfig.imageSizeMultiplier,
                                            width: 8 *
                                                SizeConfig.imageSizeMultiplier,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            child: Container(
                                              margin: EdgeInsets.all(1),
                                              alignment: Alignment.center,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey
                                                      .withOpacity(.3)),
                                              child: Icon(
                                                Icons.photo_camera,
                                                size: 5 *
                                                    SizeConfig
                                                        .imageSizeMultiplier,
                                                color: MyColors.primaryColor
                                                    .withOpacity(.7),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 2.5 * SizeConfig.heightMultiplier),
                        alignment: Alignment.center,
                        child: Text(
                          profile.name == null ? "-" : profile.name,
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProMedium,
                              fontSize: 2.2 * SizeConfig.textMultiplier,
                              color: MyColors.primaryColor),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 3 * SizeConfig.heightMultiplier,
                            right: 2.5 * SizeConfig.widthMultiplier,
                            left: 2.5 * SizeConfig.widthMultiplier),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 24 * SizeConfig.widthMultiplier,
                              child: Text(
                                AppLocalizations.of(context)
                                        .translate("your_email") +
                                    ":",
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProBold,
                                    fontSize: 2.15 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Container(
                                child: isEditEmail
                                    ? TextFormField(
                                        controller: editEmailController,
                                        cursorColor: MyColors.primaryColor,
                                        textAlign: TextAlign.start,
                                        autofocus: false,
                                        style: TextStyle(
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier,
                                          fontFamily: FontUtils.ceraProMedium,
                                          color: MyColors.primaryColor,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 1.0 *
                                                  SizeConfig.heightMultiplier,
                                              horizontal: 3.0 *
                                                  SizeConfig.widthMultiplier),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: MyColors.primaryColor),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: MyColors.primaryColor),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        editEmailController.text == null
                                            ? "-"
                                            : editEmailController.text,
                                        style: TextStyle(
                                          fontFamily: FontUtils.ceraProMedium,
                                          fontSize:
                                              2.1 * SizeConfig.textMultiplier,
                                          color: MyColors.primaryColor,
                                        ),
                                      ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: onEditEmailTap,
                                child: Container(
                                  child: !isEditEmail
                                      ? Text(
                                          CommonUtils.translate(
                                              context, "edit"),
                                          style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize: 1.65 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue,
                                          ),
                                        )
                                      : Icon(Icons.done,
                                          color: MyColors.primaryColor),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 2 * SizeConfig.heightMultiplier,
                            right: 2.5 * SizeConfig.widthMultiplier,
                            left: 2.5 * SizeConfig.widthMultiplier),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 24 * SizeConfig.widthMultiplier,
                              child: Text(
                                AppLocalizations.of(context)
                                        .translate("your_mobile") +
                                    ":",
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProBold,
                                    fontSize: 2.15 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor,
                                    decoration: TextDecoration.underline),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Container(
                                child: isEditNumber
                                    ? TextFormField(
                                        controller: editNumberController,
                                        cursorColor: MyColors.primaryColor,
                                        textAlign: TextAlign.start,
                                        autofocus: false,
                                        style: TextStyle(
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier,
                                          fontFamily: FontUtils.ceraProMedium,
                                          color: MyColors.primaryColor,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 1.0 *
                                                  SizeConfig.heightMultiplier,
                                              horizontal: 3.0 *
                                                  SizeConfig.widthMultiplier),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: MyColors.primaryColor),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: MyColors.primaryColor),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        editNumberController.text == null
                                            ? "-"
                                            : editNumberController.text,
                                        style: TextStyle(
                                          fontFamily: FontUtils.ceraProMedium,
                                          fontSize:
                                              2.1 * SizeConfig.textMultiplier,
                                          color: MyColors.primaryColor,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: onEditNumberTap,
                                child: Container(
                                  child: !isEditNumber
                                      ? Text(
                                          CommonUtils.translate(
                                              context, "edit"),
                                          style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize: 1.65 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue,
                                          ),
                                        )
                                      : Icon(Icons.done,
                                          color: MyColors.primaryColor),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 2 * SizeConfig.heightMultiplier,
                            right: 2.5 * SizeConfig.widthMultiplier,
                            left: 2.5 * SizeConfig.widthMultiplier),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 24 * SizeConfig.widthMultiplier,
                              child: Text(
                                AppLocalizations.of(context)
                                        .translate("password") +
                                    ":",
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProBold,
                                    fontSize: 2.15 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Container(
                                child: Text(
                                  "",
                                  style: TextStyle(
                                    fontFamily: FontUtils.ceraProMedium,
                                    fontSize: 2.1 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 2 * SizeConfig.heightMultiplier,
                            right: 2.5 * SizeConfig.widthMultiplier,
                            left: 2.5 * SizeConfig.widthMultiplier),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 24 * SizeConfig.widthMultiplier,
                              child: Text(
                                AppLocalizations.of(context)
                                        .translate("country") +
                                    ":",
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProBold,
                                    fontSize: 2.15 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Container(
                                child: Text(
                                  profile.country == null ||
                                          profile.country.name == null
                                      ? "-"
                                      : profile.country.name,
                                  style: TextStyle(
                                    fontFamily: FontUtils.ceraProMedium,
                                    fontSize: 2.1 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 2 * SizeConfig.heightMultiplier,
                            right: 2.5 * SizeConfig.widthMultiplier,
                            left: 2.5 * SizeConfig.widthMultiplier),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 24 * SizeConfig.widthMultiplier,
                              child: Text(
                                AppLocalizations.of(context)
                                        .translate("state") +
                                    ":",
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProBold,
                                    fontSize: 2.15 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Container(
                                child: Text(
                                  profile.state == null ||
                                          profile.state.name == null
                                      ? ""
                                      : profile.state.name,
                                  style: TextStyle(
                                    fontFamily: FontUtils.ceraProMedium,
                                    fontSize: 2.1 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 2 * SizeConfig.heightMultiplier,
                            right: 2.5 * SizeConfig.widthMultiplier,
                            left: 2.5 * SizeConfig.widthMultiplier),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 24 * SizeConfig.widthMultiplier,
                              child: Text(
                                AppLocalizations.of(context)
                                        .translate("address") +
                                    ":",
                                style: TextStyle(
                                    fontFamily: FontUtils.ceraProBold,
                                    fontSize: 2.15 * SizeConfig.textMultiplier,
                                    color: MyColors.primaryColor,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Container(
                                child: isEditAddress
                                    ? TextFormField(
                                        controller: editAddressController,
                                        cursorColor: MyColors.primaryColor,
                                        textAlign: TextAlign.start,
                                        autofocus: false,
                                        style: TextStyle(
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier,
                                          fontFamily: FontUtils.ceraProMedium,
                                          color: MyColors.primaryColor,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 1.0 *
                                                  SizeConfig.heightMultiplier,
                                              horizontal: 3.0 *
                                                  SizeConfig.widthMultiplier),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: MyColors.primaryColor),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: MyColors.primaryColor),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        editAddressController.text == null
                                            ? "-"
                                            : editAddressController.text,
                                        style: TextStyle(
                                          fontFamily: FontUtils.ceraProMedium,
                                          fontSize:
                                              2.1 * SizeConfig.textMultiplier,
                                          color: MyColors.primaryColor,
                                        ),
                                      ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: onEditAddressTap,
                                child: Container(
                                  child: !isEditAddress
                                      ? Text(
                                          CommonUtils.translate(
                                              context, "edit"),
                                          style: TextStyle(
                                            fontFamily: FontUtils.ceraProBold,
                                            fontSize: 1.65 *
                                                SizeConfig.textMultiplier,
                                            color: Colors.blue,
                                          ),
                                        )
                                      : Icon(Icons.done,
                                          color: MyColors.primaryColor),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: 3 * SizeConfig.heightMultiplier,
                            top: 7.5 * SizeConfig.heightMultiplier),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: CommonUtils.getLanguage(context) !=
                                            "english"
                                        ? 6.5 * SizeConfig.widthMultiplier
                                        : 3.5 * SizeConfig.widthMultiplier,
                                    left: CommonUtils.getLanguage(context) !=
                                            "english"
                                        ? 3.5 * SizeConfig.widthMultiplier
                                        : 6.5 * SizeConfig.widthMultiplier),
                                child: MaterialButton(
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .translate("save"),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              2.3 * SizeConfig.textMultiplier,
                                          fontFamily:
                                              FontUtils.ceraProRegular)),
                                  onPressed: isUpdating ? null : updateProfile,
                                  height: 5 * SizeConfig.heightMultiplier,
                                  minWidth: double.infinity,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.8 *
                                              SizeConfig.imageSizeMultiplier))),
                                  color: MyColors.primaryColor,
                                  elevation: 0.0,
                                  highlightElevation: 0.0,
                                  disabledColor:
                                      MyColors.primaryColor.withOpacity(.8),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: CommonUtils.getLanguage(context) ==
                                            "english"
                                        ? 6.5 * SizeConfig.widthMultiplier
                                        : 3.5 * SizeConfig.widthMultiplier,
                                    left: CommonUtils.getLanguage(context) ==
                                            "english"
                                        ? 3.5 * SizeConfig.widthMultiplier
                                        : 6.5 * SizeConfig.widthMultiplier),
                                child: MaterialButton(
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .translate("cancel"),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              2.3 * SizeConfig.textMultiplier,
                                          fontFamily:
                                              FontUtils.ceraProRegular)),
                                  onPressed: () {
                                    // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MobileVerification()));
                                  },
                                  height: 5 * SizeConfig.heightMultiplier,
                                  minWidth: double.infinity,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2.8 *
                                              SizeConfig.imageSizeMultiplier))),
                                  color: MyColors.primaryColor,
                                  elevation: 0.0,
                                  highlightElevation: 0.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
          isLoading ? MyLoader() : Container()
        ],
      ),
    );
  }
}
