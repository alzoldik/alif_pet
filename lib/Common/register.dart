import 'package:alif_pet/Apis/common_apis.dart';
import 'package:alif_pet/Common/email_verification.dart';
import 'package:alif_pet/Common/mobile_verification.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/Utils/string_utils.dart';
import 'package:alif_pet/Utils/toast_utils.dart';
import 'package:alif_pet/language/app_localization.dart';
import 'package:alif_pet/models/country.dart';
import 'package:alif_pet/models/state.dart' as country_state;
import 'package:alif_pet/models/verificatedModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'app_background.dart';

class Register extends StatefulWidget {
  final String role;
  Register(this.role);
  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  int countryId, stateId, role;
  bool isRegistering = false;
  bool isLoadingCountries = true;
  List<Country> countries = List();
  List<DropdownMenuItem<Country>> countryItems = List();
  List<DropdownMenuItem<country_state.State>> stateItems = List();
  Country selectedCountry;
  country_state.State selectedState;
  String selectedAddress;
  void setUpDropDowns(dynamic countries) {
    this.countries = countries;
/*     countryItems =   this.countries.map<DropdownMenuItem<Country>>((Country value) {
       return DropdownMenuItem<Country>(
         value: value,
         child: Container(
           margin: EdgeInsets.only(left: 1.5*SizeConfig.widthMultiplier),
           child: Text(value.name,style: TextStyle(
             fontSize: 2.2 * SizeConfig.textMultiplier,
             fontFamily: FontUtils.ceraProMedium,
             color: MyColors.primaryColor,
           ),),
         ),
       );
     }).toList();*/
    for (int i = 0; i < this.countries.length; i++) {
      Country country = this.countries[i];
      countryItems.add(DropdownMenuItem<Country>(
        value: country,
        child: Container(
          margin: EdgeInsets.only(left: 1.5 * SizeConfig.widthMultiplier),
          child: Text(
            country.name,
            style: TextStyle(
              fontSize: 2.2 * SizeConfig.textMultiplier,
              fontFamily: FontUtils.ceraProMedium,
              color: MyColors.primaryColor,
            ),
          ),
        ),
      ));
    }
    stateItems = this
        .countries[0]
        .states
        .asMap()
        .values
        .map((stateValue) => DropdownMenuItem<country_state.State>(
            value: stateValue,
            child: Container(
              margin: EdgeInsets.only(left: 1.5 * SizeConfig.widthMultiplier),
              child: Text(
                stateValue.name,
                style: TextStyle(
                  fontSize: 2.2 * SizeConfig.textMultiplier,
                  fontFamily: FontUtils.ceraProMedium,
                  color: MyColors.primaryColor,
                ),
              ),
            )))
        .toList();
    selectedCountry = this.countries[0];
    countryId = this.countries[0].id;
    selectedState = this.countries[0].states[0];
    stateId = this.countries[0].states[0].id;
    selectedAddress = this.countries[0].states[0].name;
    if (mounted) {
      setState(() {
        isLoadingCountries = false;
      });
    }
  }

  @override
  void initState() {
    role = widget.role == "client"
        ? 1
        : widget.role == "doctor"
            ? 2
            : 0;
    CommonApis().getCountries().then((result) {
      if (result is String) {
        //ToastUtils.showCustomToast(context, result, Colors.white , MyColors.primaryColor);
      } else {
        setUpDropDowns(result);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        body: Stack(
          children: <Widget>[
            AppBackground(),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier),
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
                        EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier),
                    child: Text(
                      AppLocalizations.of(context).translate("register"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProMedium,
                          fontSize: 3.5 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor),
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
                      AppLocalizations.of(context).translate("name"),
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
                      controller: nameController,
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
                      AppLocalizations.of(context).translate("mobile"),
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
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
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
                          AppLocalizations.of(context).translate("email"),
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProThin,
                              fontSize: 2.6 * SizeConfig.textMultiplier,
                              color: MyColors.primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        alignment: CommonUtils.getLanguage(context) == "english"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        margin: CommonUtils.getLanguage(context) == "english"
                            ? EdgeInsets.only(
                                top: 3 * SizeConfig.heightMultiplier,
                                right: 6.5 * SizeConfig.widthMultiplier)
                            : EdgeInsets.only(
                                top: 3 * SizeConfig.heightMultiplier,
                                left: 6.5 * SizeConfig.widthMultiplier),
                        child: Text(
                          AppLocalizations.of(context).translate("optional"),
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProThin,
                              fontSize: 2.6 * SizeConfig.textMultiplier,
                              color: Colors.grey.withOpacity(.6),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    height: 6 * SizeConfig.heightMultiplier,
                    margin: EdgeInsets.only(
                        top: 1 * SizeConfig.heightMultiplier,
                        left: 6.5 * SizeConfig.widthMultiplier,
                        right: 6.5 * SizeConfig.widthMultiplier),
                    child: TextFormField(
                      controller: emailController,
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
                      controller: passwordController,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
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
                          AppLocalizations.of(context).translate("country"),
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProThin,
                              fontSize: 2.6 * SizeConfig.textMultiplier,
                              color: MyColors.primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                          alignment:
                              CommonUtils.getLanguage(context) == "english"
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          margin: CommonUtils.getLanguage(context) == "english"
                              ? EdgeInsets.only(
                                  top: 3 * SizeConfig.heightMultiplier,
                                  right: 6.5 * SizeConfig.widthMultiplier)
                              : EdgeInsets.only(
                                  top: 3 * SizeConfig.heightMultiplier,
                                  left: 6.5 * SizeConfig.widthMultiplier),
                          child: Icon(
                            Icons.my_location,
                            color: MyColors.primaryColor,
                          )),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    height:  6*SizeConfig.heightMultiplier,
                    margin: EdgeInsets.only(top: 1*SizeConfig.heightMultiplier,left: 6.5*SizeConfig.widthMultiplier,right: 6.5*SizeConfig.widthMultiplier),
                    child: TextFormField(
                      //controller: titleController,
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
                          borderRadius: BorderRadius.circular(2.8*SizeConfig.imageSizeMultiplier),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: MyColors.red),
                          borderRadius: BorderRadius.circular(2.8*SizeConfig.imageSizeMultiplier),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenUtil.getInstance().width.toDouble(),
                    height: 6 * SizeConfig.heightMultiplier,
                    margin: EdgeInsets.only(
                        top: 1 * SizeConfig.heightMultiplier,
                        left: 6.5 * SizeConfig.widthMultiplier,
                        right: 6.5 * SizeConfig.widthMultiplier),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                          color: MyColors.red.withOpacity(.5), width: 2),
                      borderRadius: BorderRadius.circular(
                          2.8 * SizeConfig.imageSizeMultiplier),
                    ),
                    child: DropdownButton<Country>(
                      onChanged: (Country value) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        selectedCountry = value;
                        countryId = selectedCountry.id;
                        stateItems = selectedCountry.states
                            .asMap()
                            .values
                            .map((stateValue) =>
                                DropdownMenuItem<country_state.State>(
                                    value: stateValue,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left:
                                              1.5 * SizeConfig.widthMultiplier),
                                      child: Text(
                                        stateValue.name,
                                        style: TextStyle(
                                          fontSize:
                                              2.2 * SizeConfig.textMultiplier,
                                          fontFamily: FontUtils.ceraProMedium,
                                          color: MyColors.primaryColor,
                                        ),
                                      ),
                                    )))
                            .toList();
                        selectedState = selectedCountry.states[0];
                        selectedAddress = selectedState.name;
                        setState(() {});
                      },
                      value: selectedCountry == null ? null : selectedCountry,
                      items: countryItems.length > 0 ? countryItems : null,
                      isExpanded: true,
                      underline: Container(),
                      icon: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 6 * SizeConfig.imageSizeMultiplier,
                          color: MyColors.primaryColor,
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
                      AppLocalizations.of(context).translate("state"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProThin,
                          fontSize: 2.6 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    width: ScreenUtil.getInstance().width.toDouble(),
                    height: 6 * SizeConfig.heightMultiplier,
                    margin: EdgeInsets.only(
                        top: 1 * SizeConfig.heightMultiplier,
                        left: 6.5 * SizeConfig.widthMultiplier,
                        right: 6.5 * SizeConfig.widthMultiplier),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                          color: MyColors.red.withOpacity(.5), width: 2),
                      borderRadius: BorderRadius.circular(
                          2.8 * SizeConfig.imageSizeMultiplier),
                    ),
                    child: DropdownButton<country_state.State>(
                      onChanged: (data) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          selectedState = data;
                          stateId = selectedState.id;
                          selectedAddress = selectedState.name;
                        });
                      },
                      items: stateItems.length > 0 ? stateItems : null,
                      value: selectedState != null ? selectedState : null,
                      isExpanded: true,
                      underline: Container(),
                      icon: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 6 * SizeConfig.imageSizeMultiplier,
                          color: MyColors.primaryColor,
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
                      AppLocalizations.of(context).translate("address"),
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
                      controller: addressController,
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
                            padding:
                                CommonUtils.getLanguage(context) == "english"
                                    ? EdgeInsets.only(
                                        left: 2 * SizeConfig.widthMultiplier)
                                    : EdgeInsets.only(
                                        right: 2 * SizeConfig.widthMultiplier),
                            child: RotationTransition(
                                turns: CommonUtils.getLanguage(context) ==
                                        "english"
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
                      onPressed: isLoadingCountries || isRegistering
                          ? null
                          : doRegister,
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
                  Container(
                    alignment: Alignment.center,
                    margin:
                        EdgeInsets.only(top: 3 * SizeConfig.heightMultiplier),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate("do_you_have_account"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProLight,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: 5 * SizeConfig.heightMultiplier),
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context).translate("login"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProRegular,
                          fontSize: 2.5 * SizeConfig.textMultiplier,
                          color: MyColors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void doRegister() {
    // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: EmailVerification(widget.role)));
    CommonUtils.checkInternet().then((isInternet) {
      if (isInternet) {
        if (nameController.text.length > 0) {
          if (mobileController.text.length > 0) {
            if (passwordController.text.length > 0) {
              if (addressController.text.length > 0) {
                Map<String, Object> registerMap = new Map();
                if (emailController.text.length > 0 &&
                    CommonUtils.isValidEmail(emailController.text)) {
                  registerMap.putIfAbsent("email", () => emailController.text);
                } else if (emailController.text.length > 0 &&
                    !CommonUtils.isValidEmail(emailController.text)) {
                  ToastUtils.showCustomToast(
                      context,
                      "Please enter a valid email address",
                      Colors.white,
                      MyColors.primaryColor);
                  return;
                }
                isRegistering = true;
                setState(() {});
                registerMap.putIfAbsent("name", () => nameController.text);
                registerMap.putIfAbsent("mobile", () => mobileController.text);
                registerMap.putIfAbsent(
                    "password", () => passwordController.text);
                registerMap.putIfAbsent(
                    "address", () => addressController.text);
                registerMap.putIfAbsent("country_id", () => countryId);
                registerMap.putIfAbsent("state_id", () => stateId);
                registerMap.putIfAbsent("role", () => role);
                //  String registerMapJson = json.encode(registerMap);
                //  List<int> bodyBytes = utf8.encode(Uri.encodeQueryComponent(registerMapJson));

                CommonApis()
                    .register(registerMap,
                        CommonUtils.getLanguage(context) == "english")
                    .then((result) {
                  if (result is bool && result) {
                    isRegistering = false;
                    setState(() {});
                    VerificationModel verificationModel =
                        new VerificationModel();
                    verificationModel.numnber = mobileController.text;
                    verificationModel.email = emailController.text;
                    verificationModel.role = role;
                    if (emailController.text.length > 0) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: EmailVerification(
                                  verificationModel: verificationModel)),
                          (Route<dynamic> route) => false);
                    } else {
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: MobileVerification(
                                verificationModel: verificationModel,
                                fromLogin: false,
                              )),
                          (Route<dynamic> route) => false);
                    }
                  } else if (result is String) {
                    isRegistering = false;
                    setState(() {});
                    ToastUtils.showCustomToast(
                        context, result, Colors.white, MyColors.primaryColor);
                  }
                });
              } else {
                ToastUtils.showCustomToast(context, "Please Enter Address",
                    Colors.white, MyColors.primaryColor);
              }
            } else {
              ToastUtils.showCustomToast(context, "Please Enter Password",
                  Colors.white, MyColors.primaryColor);
            }
          } else {
            ToastUtils.showCustomToast(context, "Please Enter MobileNumber",
                Colors.white, MyColors.primaryColor);
          }
        } else {
          ToastUtils.showCustomToast(context, "Please Enter Name", Colors.white,
              MyColors.primaryColor);
        }
      } else {
        ToastUtils.showCustomToast(context, StringUtils.noInternet,
            Colors.white, MyColors.primaryColor);
      }
    });
  }
}
