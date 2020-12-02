import 'package:alif_pet/Apis/common_apis.dart';
import 'package:alif_pet/Apis/doctor_apis.dart';
import 'package:alif_pet/Client/client_transactions.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/Utils/string_utils.dart';
import 'package:alif_pet/Utils/toast_utils.dart';
import 'package:alif_pet/models/balance.dart';
import 'package:alif_pet/models/success.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class DoctorWalletBalance extends StatefulWidget {
  @override
  _DoctorWalletBalanceState createState() => _DoctorWalletBalanceState();
}

class _DoctorWalletBalanceState extends State<DoctorWalletBalance> {
  bool isEnglish;
  bool isLoadingBalance = true;
  bool isAddingBalance = false;
  final addBalanceController = TextEditingController();
  final nameController = TextEditingController();
  final bankController = TextEditingController();
  final ibanController = TextEditingController();
  Balance balance;
  void getBalance() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        CommonApis().getBalance(isEnglish).then((value) {
          if (value is String) {
            ToastUtils.showCustomToast(
                context, value, Colors.white, MyColors.primaryColor);
            isLoadingBalance = false;
            if (mounted) {
              setState(() {});
            }
          } else {
            balance = value;
            isLoadingBalance = false;
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

  void withdrawRequest() {
    if (addBalanceController.text.length > 0) {
      if (nameController.text.length > 0) {
        if (bankController.text.length > 0) {
          if (ibanController.text.length > 0) {
            CommonUtils.checkInternet().then((value) {
              if (value) {
                isAddingBalance = true;
                setState(() {});
                DoctorApis().withdrawRequest({
                  "amount": int.parse(addBalanceController.text),
                  "account_name": nameController.text,
                  "bank_name": bankController.text,
                  "IBAN": ibanController.text
                }, isEnglish).then((value) {
                  if (value is String) {
                    ToastUtils.showCustomToast(
                        context, value, Colors.white, MyColors.primaryColor);
                    isAddingBalance = false;
                    if (mounted) {
                      setState(() {});
                    }
                  } else {
                    Success success = value;
                    ToastUtils.showCustomToast(
                        context,
                        isEnglish ? success.en : success.ar,
                        Colors.white,
                        MyColors.primaryColor);
                    addBalanceController.clear();
                    nameController.clear();
                    bankController.clear();
                    ibanController.clear();
                    isLoadingBalance = true;
                    isAddingBalance = false;
                    if (mounted) {
                      setState(() {});
                    }
                    getBalance();
                  }
                });
              } else {
                ToastUtils.showCustomToast(context, StringUtils.noInternet,
                    Colors.white, MyColors.primaryColor);
              }
            });
          } else {
            ToastUtils.showCustomToast(
                context,
                CommonUtils.translate(context, "enter_iban"),
                Colors.white,
                MyColors.primaryColor);
          }
        } else {
          ToastUtils.showCustomToast(
              context,
              CommonUtils.translate(context, "enter_bank_name"),
              Colors.white,
              MyColors.primaryColor);
        }
      } else {
        ToastUtils.showCustomToast(
            context,
            CommonUtils.translate(context, "enter_name"),
            Colors.white,
            MyColors.primaryColor);
      }
    } else {
      ToastUtils.showCustomToast(
          context,
          CommonUtils.translate(context, "add_amount"),
          Colors.white,
          MyColors.primaryColor);
    }
  }

  @override
  void initState() {
    addBalanceController.addListener(() {});
    nameController.addListener(() {});
    bankController.addListener(() {});
    ibanController.addListener(() {});
    getBalance();
    super.initState();
  }

  @override
  void dispose() {
    addBalanceController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    isEnglish = CommonUtils.getLanguage(context) == "english";
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomPadding: true,
      body: Container(
        margin: EdgeInsets.only(
          right: 2.5 * SizeConfig.widthMultiplier,
          left: 2.5 * SizeConfig.widthMultiplier,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        margin: CommonUtils.getLanguage(context) == "english"
                            ? EdgeInsets.only(
                                left: 2.5 * SizeConfig.widthMultiplier)
                            : EdgeInsets.only(
                                right: 2.5 * SizeConfig.widthMultiplier),
                        child: Text(
                          CommonUtils.translate(context, "current_balance"),
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProRegular,
                              fontSize: 2.2 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: MyColors.primaryColor),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Text(
                          isLoadingBalance
                              ? "..."
                              : "${balance.balance} ${isEnglish ? balance.currency.en : balance.currency.ar}",
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProRegular,
                              fontSize: 2.2 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold,
                              color: MyColors.dark_red),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 5.5 * SizeConfig.heightMultiplier),
                child: MaterialButton(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 1.5 * SizeConfig.widthMultiplier),
                    child: Text(
                        CommonUtils.translate(context, "view_transactions"),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 2.3 * SizeConfig.textMultiplier,
                            fontFamily: FontUtils.ceraProMedium)),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: ClientTransactions()));
                  },
                  height: 5 * SizeConfig.heightMultiplier,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(
                          2.8 * SizeConfig.imageSizeMultiplier))),
                  color: MyColors.primaryColor,
                  elevation: 0.0,
                  highlightElevation: 0.0,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier),
                height: 1.7 * SizeConfig.heightMultiplier,
                width: ScreenUtil.getInstance().width.toDouble(),
                color: MyColors.right_chat_item_color,
              ),
              Container(
                margin: CommonUtils.getLanguage(context) == "english"
                    ? EdgeInsets.only(
                        left: 3 * SizeConfig.widthMultiplier,
                        top: 3 * SizeConfig.heightMultiplier)
                    : EdgeInsets.only(
                        right: 3 * SizeConfig.widthMultiplier,
                        top: 3 * SizeConfig.heightMultiplier),
                width: ScreenUtil.getInstance().width.toDouble(),
                child: Text(
                  CommonUtils.translate(context, "request_withdrawal"),
                  style: TextStyle(
                      fontFamily: FontUtils.ceraProRegular,
                      fontSize: 2.2 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: MyColors.primaryColor),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 3 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 3 * SizeConfig.widthMultiplier),
                      child: Text(
                        CommonUtils.translate(context, "add_balance"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProRegular,
                            fontSize: 2.2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: MyColors.primaryColor),
                      ),
                    ),
                    Container(
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 2 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 2 * SizeConfig.widthMultiplier),
                      height: 5 * SizeConfig.heightMultiplier,
                      width: 20 * SizeConfig.widthMultiplier,
                      /*   decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                          border: Border.all(color: MyColors.primaryColor.withOpacity(.8),width: 1.5)
                      ),*/
                      child: TextFormField(
                        controller: addBalanceController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        autofocus: false,
                        style: TextStyle(
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          fontFamily: FontUtils.ceraProMedium,
                          color: MyColors.primaryColor,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 1 * SizeConfig.heightMultiplier,
                              horizontal: 1 * SizeConfig.widthMultiplier),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                3 * SizeConfig.imageSizeMultiplier)),
                            borderSide: BorderSide(
                                color: MyColors.primaryColor.withOpacity(.8),
                                width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                3 * SizeConfig.imageSizeMultiplier)),
                            borderSide: BorderSide(
                                color: MyColors.primaryColor.withOpacity(.8),
                                width: 1.5),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 5 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 5 * SizeConfig.widthMultiplier),
                      child: Text(
                        CommonUtils.translate(context, "currency"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProMedium,
                            fontSize: 2.2 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor.withOpacity(.8)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: CommonUtils.getLanguage(context) == "english"
                    ? EdgeInsets.only(
                        left: 3 * SizeConfig.widthMultiplier,
                        top: 1.5 * SizeConfig.heightMultiplier)
                    : EdgeInsets.only(
                        right: 3 * SizeConfig.widthMultiplier,
                        top: 1.5 * SizeConfig.heightMultiplier),
                width: ScreenUtil.getInstance().width.toDouble(),
                child: Text(
                  CommonUtils.translate(context, "bank_details"),
                  style: TextStyle(
                      fontFamily: FontUtils.ceraProRegular,
                      fontSize: 2.2 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: MyColors.primaryColor),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 13 * SizeConfig.widthMultiplier,
                      child: Text(
                        CommonUtils.translate(context, "name") + ":",
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProBold,
                            fontSize: 2.0 * SizeConfig.textMultiplier,
                            decoration: TextDecoration.underline,
                            color: MyColors.primaryColor),
                      ),
                    ),
                    Container(
                      width: ScreenUtil.getInstance().width * .55,
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 2 * SizeConfig.widthMultiplier,
                              right: 6.5 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 2 * SizeConfig.widthMultiplier,
                              left: 6.5 * SizeConfig.widthMultiplier),
                      height: 5 * SizeConfig.heightMultiplier,
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        autofocus: false,
                        style: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                          fontFamily: FontUtils.ceraProMedium,
                          color: MyColors.primaryColor,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 1 * SizeConfig.heightMultiplier,
                              horizontal: 1 * SizeConfig.widthMultiplier),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                3 * SizeConfig.imageSizeMultiplier)),
                            borderSide: BorderSide(
                                color: MyColors.primaryColor.withOpacity(.8),
                                width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                3 * SizeConfig.imageSizeMultiplier)),
                            borderSide: BorderSide(
                                color: MyColors.primaryColor.withOpacity(.8),
                                width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 13 * SizeConfig.widthMultiplier,
                      child: Text(
                        CommonUtils.translate(context, "bank") + ":",
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProBold,
                            fontSize: 2.0 * SizeConfig.textMultiplier,
                            decoration: TextDecoration.underline,
                            color: MyColors.primaryColor),
                      ),
                    ),
                    Container(
                      width: ScreenUtil.getInstance().width * .55,
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 2 * SizeConfig.widthMultiplier,
                              right: 6.5 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 2 * SizeConfig.widthMultiplier,
                              left: 6.5 * SizeConfig.widthMultiplier),
                      height: 5 * SizeConfig.heightMultiplier,
                      child: TextFormField(
                        controller: bankController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        autofocus: false,
                        style: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                          fontFamily: FontUtils.ceraProMedium,
                          color: MyColors.primaryColor,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 1 * SizeConfig.heightMultiplier,
                              horizontal: 1 * SizeConfig.widthMultiplier),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                3 * SizeConfig.imageSizeMultiplier)),
                            borderSide: BorderSide(
                                color: MyColors.primaryColor.withOpacity(.8),
                                width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                3 * SizeConfig.imageSizeMultiplier)),
                            borderSide: BorderSide(
                                color: MyColors.primaryColor.withOpacity(.8),
                                width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 13 * SizeConfig.widthMultiplier,
                      child: Text(
                        "IBAN:",
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProBold,
                            fontSize: 2.0 * SizeConfig.textMultiplier,
                            decoration: TextDecoration.underline,
                            color: MyColors.primaryColor),
                      ),
                    ),
                    Container(
                      width: ScreenUtil.getInstance().width * .55,
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 2 * SizeConfig.widthMultiplier,
                              right: 6.5 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 2 * SizeConfig.widthMultiplier,
                              left: 6.5 * SizeConfig.widthMultiplier),
                      height: 5 * SizeConfig.heightMultiplier,
                      child: TextFormField(
                        controller: ibanController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        autofocus: false,
                        style: TextStyle(
                          fontSize: 2 * SizeConfig.textMultiplier,
                          fontFamily: FontUtils.ceraProMedium,
                          color: MyColors.primaryColor,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 1 * SizeConfig.heightMultiplier,
                              horizontal: 1 * SizeConfig.widthMultiplier),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                3 * SizeConfig.imageSizeMultiplier)),
                            borderSide: BorderSide(
                                color: MyColors.primaryColor.withOpacity(.8),
                                width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(
                                3 * SizeConfig.imageSizeMultiplier)),
                            borderSide: BorderSide(
                                color: MyColors.primaryColor.withOpacity(.8),
                                width: 1.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 3.5 * SizeConfig.heightMultiplier),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(
                            right: CommonUtils.getLanguage(context) != "english"
                                ? 6.5 * SizeConfig.widthMultiplier
                                : 3.5 * SizeConfig.widthMultiplier,
                            left: CommonUtils.getLanguage(context) != "english"
                                ? 3.5 * SizeConfig.widthMultiplier
                                : 6.5 * SizeConfig.widthMultiplier),
                        child: MaterialButton(
                          child: Text(CommonUtils.translate(context, "send"),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 2.3 * SizeConfig.textMultiplier,
                                  fontFamily: FontUtils.ceraProRegular,
                                  fontWeight: FontWeight.bold)),
                          onPressed: isAddingBalance ? null : withdrawRequest,
                          height: 5 * SizeConfig.heightMultiplier,
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
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(
                            right: CommonUtils.getLanguage(context) == "english"
                                ? 6.5 * SizeConfig.widthMultiplier
                                : 3.5 * SizeConfig.widthMultiplier,
                            left: CommonUtils.getLanguage(context) == "english"
                                ? 3.5 * SizeConfig.widthMultiplier
                                : 6.5 * SizeConfig.widthMultiplier),
                        child: MaterialButton(
                          child: Text(CommonUtils.translate(context, "cancel"),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 2.3 * SizeConfig.textMultiplier,
                                  fontFamily: FontUtils.ceraProRegular,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MobileVerification()));
                          },
                          height: 5 * SizeConfig.heightMultiplier,
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  2.8 * SizeConfig.imageSizeMultiplier))),
                          color: MyColors.primaryColor,
                          elevation: 0.0,
                          highlightElevation: 0.0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
