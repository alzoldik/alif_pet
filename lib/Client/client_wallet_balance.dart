import 'package:alif_pet/Apis/client_apis.dart';
import 'package:alif_pet/Apis/common_apis.dart';
import 'package:alif_pet/Client/add_balance_screen.dart';
import 'package:alif_pet/Client/client_transactions.dart';
import 'package:alif_pet/Services/user_service.dart';
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
import 'package:provider/provider.dart';

class ClientWalletBalance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClientWalletBalanceState();
  }
}

class ClientWalletBalanceState extends State<ClientWalletBalance> {
  var payBy;
  bool isEnglish;
  bool isLoadingBalance = true;
  bool isAddingBalance = false;
  final addBalanceController = TextEditingController();
  Balance balance;
  UserService userService;
  @override
  void initState() {
    addBalanceController.addListener(() {});
    getBalance();
    super.initState();
  }

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

  void addBalance() {
    if (addBalanceController.text.length > 0) {
      CommonUtils.checkInternet().then((value) {
        if (value) {
          isAddingBalance = true;
          if (mounted) {
            setState(() {});
          }
          ClientApis().addBalance(
              {"amount": int.parse(addBalanceController.text)},
              isEnglish).then((value) {
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
    }
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
    userService = Provider.of<UserService>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(
        top: 11.5 * SizeConfig.heightMultiplier,
        bottom: 10.5 * SizeConfig.heightMultiplier,
        right: 2.5 * SizeConfig.widthMultiplier,
        left: 2.5 * SizeConfig.widthMultiplier,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    width: ScreenUtil.getInstance().width * .40,
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(left: 3 * SizeConfig.widthMultiplier)
                        : EdgeInsets.only(
                            right: 3 * SizeConfig.widthMultiplier),
                    child: Text(
                      CommonUtils.translate(context, "current_balance"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProBold,
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          decoration: TextDecoration.underline,
                          color: MyColors.primaryColor),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: ScreenUtil.getInstance().width * .40,
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(left: 3 * SizeConfig.widthMultiplier)
                        : EdgeInsets.only(
                            right: 3 * SizeConfig.widthMultiplier),
                    child: Text(
                      isLoadingBalance
                          ? "..."
                          : "${balance.balance} ${isEnglish ? balance.currency.en : balance.currency.ar}",
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProBold,
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          color: MyColors.dark_red),
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 2.5 * SizeConfig.heightMultiplier),
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
                    borderRadius: BorderRadius.all(
                        Radius.circular(2.8 * SizeConfig.imageSizeMultiplier))),
                color: MyColors.primaryColor,
                elevation: 0.0,
                highlightElevation: 0.0,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 3.5 * SizeConfig.heightMultiplier),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(left: 3 * SizeConfig.widthMultiplier)
                        : EdgeInsets.only(
                            right: 3 * SizeConfig.widthMultiplier),
                    child: Text(
                      CommonUtils.translate(context, "add_balance"),
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProBold,
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          decoration: TextDecoration.underline,
                          color: MyColors.primaryColor),
                    ),
                  ),
                  Container(
                    margin: CommonUtils.getLanguage(context) == "english"
                        ? EdgeInsets.only(left: 2 * SizeConfig.widthMultiplier)
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
                        ? EdgeInsets.only(left: 5 * SizeConfig.widthMultiplier)
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
                  SizedBox(
                    width: 2 * SizeConfig.widthMultiplier,
                  ),
                  Container(
                    child: MaterialButton(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 1.5 * SizeConfig.widthMultiplier),
                        child: Text(CommonUtils.translate(context, "next"),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 2.3 * SizeConfig.textMultiplier,
                                fontFamily: FontUtils.ceraProMedium)),
                      ),
                      onPressed: () async {
                        if (addBalanceController.text.length > 0) {
                          dynamic result = await Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: AddBalanceScreen(
                                      addBalanceController.text,
                                      userService.profile.id.toString())));
                          if (result) {
                            getBalance();
                          }
                        }
                      },
                      height: 5 * SizeConfig.heightMultiplier,
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
            ),
            /*    Container(
              width: ScreenUtil.getInstance().width.toDouble(),
              margin: CommonUtils.getLanguage(context)=="english"? EdgeInsets.only(left: 3*SizeConfig.widthMultiplier,top: 1*SizeConfig.heightMultiplier):
              EdgeInsets.only(right: 3*SizeConfig.widthMultiplier,top: 1*SizeConfig.heightMultiplier),
              child: Text(
                CommonUtils.translate(context, "pay_using"),
                style: TextStyle(
                    fontFamily: FontUtils.ceraProBold,
                    fontSize: 2.2 * SizeConfig.textMultiplier,
                    decoration: TextDecoration.underline,
                    color: MyColors.primaryColor),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 1*SizeConfig.heightMultiplier,left: 3*SizeConfig.widthMultiplier,right: 3*SizeConfig.widthMultiplier),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      setState(() {
                        if(payBy=="bank"){
                          payBy = null;
                        }else{
                          payBy = "bank";
                        }

                      });
                    },
                    child: Container(
                      width: ScreenUtil.getInstance().width.toDouble(),
                      height: 7.3*SizeConfig.heightMultiplier,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: MyColors.left_chat_item_color,
                          border: Border.all(color: MyColors.right_chat_item_color,width: .7,)
                      ),
                      child: Align(
                        alignment: CommonUtils.getLanguage(context)=="english"? Alignment.centerLeft : Alignment.centerRight,
                        child: Padding(
                          padding: CommonUtils.getLanguage(context)=="english"? EdgeInsets.only(left: 2.5*SizeConfig.widthMultiplier) : EdgeInsets.only(right: 2.5*SizeConfig.widthMultiplier),
                          child: Text(
                            CommonUtils.translate(context, "bank_card"),
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProBold,
                                fontSize: 2 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  payBy!=null && payBy=="bank"?Container(
                      width: ScreenUtil.getInstance().width.toDouble(),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border(left: BorderSide(color :MyColors.right_chat_item_color,width: .7),right: BorderSide(color :MyColors.right_chat_item_color,width: .7))
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 20*SizeConfig.widthMultiplier,
                                margin:  CommonUtils.getLanguage(context)=="english"? EdgeInsets.only(left: 3*SizeConfig.widthMultiplier) : EdgeInsets.only(right: 3*SizeConfig.widthMultiplier),
                                child: Text(
                                    CommonUtils.translate(context, "card_number"),
                                  style: TextStyle(
                                      fontFamily: FontUtils.ceraProMedium,
                                      fontSize: 2.2 * SizeConfig.textMultiplier,
                                      color: MyColors.primaryColor),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: CommonUtils.getLanguage(context)=="english"? EdgeInsets.only(left: 2*SizeConfig.widthMultiplier,right: 6.5*SizeConfig.widthMultiplier):
                                  EdgeInsets.only(right: 2*SizeConfig.widthMultiplier,left: 6.5*SizeConfig.widthMultiplier),
                                  height: 5*SizeConfig.heightMultiplier,
                                  */ /*   decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                        border: Border.all(color: MyColors.primaryColor.withOpacity(.8),width: 1.5)
                    ),*/ /*
                                  child: TextFormField(
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
                                      prefixIcon: Icon(Icons.credit_card,color: MyColors.primaryColor,),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 1 * SizeConfig.heightMultiplier,
                                          horizontal: 1 * SizeConfig.widthMultiplier),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                                        borderSide: BorderSide(color:  MyColors.primaryColor.withOpacity(.8),width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                                        borderSide: BorderSide(color:  MyColors.primaryColor.withOpacity(.8),width: 1.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 1.5*SizeConfig.heightMultiplier),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 20*SizeConfig.widthMultiplier,
                                  margin: CommonUtils.getLanguage(context)=="english"? EdgeInsets.only(left: 3*SizeConfig.widthMultiplier) :
                                  EdgeInsets.only(right: 3*SizeConfig.widthMultiplier),
                                  child: Text(
                                    CommonUtils.translate(context, "expires_on"),
                                    style: TextStyle(
                                        fontFamily: FontUtils.ceraProMedium,
                                        fontSize: 2.2 * SizeConfig.textMultiplier,
                                        color: MyColors.primaryColor),
                                  ),
                                ),
                                Container(
                                  margin: CommonUtils.getLanguage(context)=="english"?  EdgeInsets.only(left: 2*SizeConfig.widthMultiplier) :
                                  EdgeInsets.only(right: 2*SizeConfig.widthMultiplier),
                                  height: 5*SizeConfig.heightMultiplier,
                                  width: 15*SizeConfig.widthMultiplier,
                                  */ /*   decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                        border: Border.all(color: MyColors.primaryColor.withOpacity(.8),width: 1.5)
                    ),*/ /*
                                  child: TextFormField(
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
                                        borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                                        borderSide: BorderSide(color:  MyColors.primaryColor.withOpacity(.8),width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                                        borderSide: BorderSide(color:  MyColors.primaryColor.withOpacity(.8),width: 1.5),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: CommonUtils.getLanguage(context)=="english"? EdgeInsets.only(left: 2*SizeConfig.widthMultiplier) : EdgeInsets.only(right: 2*SizeConfig.widthMultiplier),
                                  height: 5*SizeConfig.heightMultiplier,
                                  width: 15*SizeConfig.widthMultiplier,
                                  */ /*   decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                        border: Border.all(color: MyColors.primaryColor.withOpacity(.8),width: 1.5)
                    ),*/ /*
                                  child: TextFormField(
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
                                        borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                                        borderSide: BorderSide(color:  MyColors.primaryColor.withOpacity(.8),width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                                        borderSide: BorderSide(color:  MyColors.primaryColor.withOpacity(.8),width: 1.5),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 1.5*SizeConfig.heightMultiplier),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 20*SizeConfig.widthMultiplier,
                                  margin: CommonUtils.getLanguage(context)=="english"? EdgeInsets.only(left: 3*SizeConfig.widthMultiplier) : EdgeInsets.only(right: 3*SizeConfig.widthMultiplier),
                                  child: Text(
                                    "CCV",
                                    style: TextStyle(
                                        fontFamily: FontUtils.ceraProMedium,
                                        fontSize: 2.2 * SizeConfig.textMultiplier,
                                        color: MyColors.primaryColor),
                                  ),
                                ),
                                Container(
                                  margin: CommonUtils.getLanguage(context)=="english"? EdgeInsets.only(left: 2*SizeConfig.widthMultiplier) : EdgeInsets.only(right: 2*SizeConfig.widthMultiplier),
                                  height: 5*SizeConfig.heightMultiplier,
                                  width: 15*SizeConfig.widthMultiplier,
                                  */ /*   decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                        border: Border.all(color: MyColors.primaryColor.withOpacity(.8),width: 1.5)
                    ),*/ /*
                                  child: TextFormField(
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
                                        borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                                        borderSide: BorderSide(color:  MyColors.primaryColor.withOpacity(.8),width: 1.5),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                                        borderSide: BorderSide(color:  MyColors.primaryColor.withOpacity(.8),width: 1.5),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                  ):Container(),
                  InkWell(
                    onTap: (){
                      setState(() {
                       if(payBy=="mada"){
                         payBy = null;
                       }else{
                         payBy = "mada";
                       }
                      });
                    },
                    child: Container(
                      width: ScreenUtil.getInstance().width.toDouble(),
                      height: 7.3*SizeConfig.heightMultiplier,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: MyColors.left_chat_item_color,
                          border: Border.all(color: MyColors.right_chat_item_color,width: .7,)
                      ),
                      child: Align(
                        alignment: CommonUtils.getLanguage(context)=="english"? Alignment.centerLeft : Alignment.centerRight,
                        child: Padding(
                          padding: CommonUtils.getLanguage(context)=="english"? EdgeInsets.only(left: 2.5*SizeConfig.widthMultiplier) : EdgeInsets.only(right: 2.5*SizeConfig.widthMultiplier),
                          child: Text(
                            CommonUtils.translate(context, "mada"),
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProBold,
                                fontSize: 2 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                 payBy!=null && payBy=="mada" ? Container(
                   height: 7.3*SizeConfig.heightMultiplier,
                   decoration: BoxDecoration(
                       shape: BoxShape.rectangle,
                       border: Border(left: BorderSide(color :MyColors.right_chat_item_color,width: .7),right: BorderSide(color :MyColors.right_chat_item_color,width: .7),bottom:BorderSide(color :MyColors.right_chat_item_color,width: .7) )
                   ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 20*SizeConfig.widthMultiplier,
                          margin: CommonUtils.getLanguage(context)=="english"? EdgeInsets.only(left: 3*SizeConfig.widthMultiplier) : EdgeInsets.only(right: 3*SizeConfig.widthMultiplier),
                          child: Text(
                           CommonUtils.translate(context, "name"),
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProMedium,
                                fontSize: 2.2 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: CommonUtils.getLanguage(context)=="english"? EdgeInsets.only(left: 2*SizeConfig.widthMultiplier,right: 6.5*SizeConfig.widthMultiplier):
                            EdgeInsets.only(right: 2*SizeConfig.widthMultiplier,left: 6.5*SizeConfig.widthMultiplier),
                            height: 5*SizeConfig.heightMultiplier,
                            */ /*   decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                          border: Border.all(color: MyColors.primaryColor.withOpacity(.8),width: 1.5)
                    ),*/ /*
                            child: TextFormField(
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
                                  borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                                  borderSide: BorderSide(color:  MyColors.primaryColor.withOpacity(.8),width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(3*SizeConfig.imageSizeMultiplier)),
                                  borderSide: BorderSide(color:  MyColors.primaryColor.withOpacity(.8),width: 1.5),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ) : Container()
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 2.5*SizeConfig.heightMultiplier),
              child: MaterialButton(
                child:  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.5*SizeConfig.widthMultiplier),
                  child: Text(CommonUtils.translate(context, "pay"),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 2.3*SizeConfig.textMultiplier,
                          fontFamily: FontUtils.ceraProMedium)),
                ),
                onPressed: null*/ /*isAddingBalance? null :addBalance*/ /*,
                height:  5*SizeConfig.heightMultiplier,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.8*SizeConfig.imageSizeMultiplier))),
                color: MyColors.primaryColor,
                elevation: 0.0,
                highlightElevation: 0.0,
                disabledColor: MyColors.primaryColor.withOpacity(.8),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
