import 'package:alif_pet/Apis/client_apis.dart';
import 'package:alif_pet/Common/app_background.dart';
import 'package:alif_pet/Common/my_loader.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientTransactions extends StatefulWidget {
  @override
  _ClientTransactionsState createState() => _ClientTransactionsState();
}

class _ClientTransactionsState extends State<ClientTransactions> {
  bool isLoading = true;
  bool isEnglish = true;
  dynamic transactions;
  List transactionValues = List();
  List transactionDates = List();
  @override
  void initState() {
    CommonUtils.checkInternet().then((value) {
      if (value) {
        ClientApis().getTransactions(isEnglish).then((value) {
          if (value is String) {
          } else {
            transactions = value;
            if (transactions is Map) {
              transactionValues = transactions.values.toList();
              transactionDates = transactions.keys.toList();
            }
            isLoading = false;
            setState(() {});
          }
        });
      } else {
        // ToastUtils.showCustomToast(context, StringUtils.noInternet, Colors.white, MyColors.primaryColor);
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    isEnglish = CommonUtils.getLanguage(context) == "english";
    super.didChangeDependencies();
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
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                height: 7.5 * SizeConfig.heightMultiplier,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
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
                    Container(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      margin: CommonUtils.getLanguage(context) == "english"
                          ? EdgeInsets.only(
                              left: 13 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 13 * SizeConfig.widthMultiplier),
                      child: Hero(
                        tag: "logo",
                        child: Material(
                          color: Colors.transparent,
                          child: Image.asset(
                            ImageUtils.logo,
                            width: 8.5 * SizeConfig.imageSizeMultiplier,
                            height: 8.5 * SizeConfig.imageSizeMultiplier,
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
                              left: 25 * SizeConfig.widthMultiplier)
                          : EdgeInsets.only(
                              right: 25 * SizeConfig.widthMultiplier),
                      child: Text(
                        CommonUtils.translate(context, "transactions"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProMedium,
                            fontSize: 2.9 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                      ),
                    ),
                    Align(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.notifications,
                              color: MyColors.primaryColor)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 12 * SizeConfig.heightMultiplier,
                  left: 4.5 * SizeConfig.widthMultiplier),
              child: isLoading
                  ? MyLoader()
                  : transactions.length == 0
                      ? Center(
                          child: Text(
                            CommonUtils.translate(context, "no_transaction"),
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProMedium,
                                fontSize: 2.9 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor),
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  bottom: 2 * SizeConfig.heightMultiplier),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: MyColors.left_chat_item_color,
                                          width: 2))),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width:
                                              27 * SizeConfig.widthMultiplier,
                                          margin: CommonUtils.getLanguage(
                                                      context) ==
                                                  "english"
                                              ? EdgeInsets.only(
                                                  left: 2 *
                                                      SizeConfig
                                                          .widthMultiplier)
                                              : EdgeInsets.only(
                                                  right: 2 *
                                                      SizeConfig
                                                          .widthMultiplier),
                                          child: Text(
                                            CommonUtils.translate(
                                                context, "description"),
                                            style: TextStyle(
                                                fontFamily:
                                                    FontUtils.ceraProRegular,
                                                fontSize: 2 *
                                                    SizeConfig.textMultiplier,
                                                fontWeight: FontWeight.bold,
                                                color: MyColors.primaryColor),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 2.5 *
                                                    SizeConfig.widthMultiplier,
                                                right: 2.5 *
                                                    SizeConfig.widthMultiplier),
                                            child: Text(
                                              transactionValues[index]
                                                  ['description'],
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontUtils.ceraProRegular,
                                                  fontSize: 1.5 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.bold,
                                                  color: MyColors.primaryColor),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 1 * SizeConfig.heightMultiplier),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          child: Container(
                                            width:
                                                27 * SizeConfig.widthMultiplier,
                                            margin: EdgeInsets.only(
                                                left: 2.5 *
                                                    SizeConfig.widthMultiplier,
                                                right: 2.5 *
                                                    SizeConfig.widthMultiplier),
                                            child: Text(
                                              CommonUtils.translate(
                                                  context, "date"),
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontUtils.ceraProRegular,
                                                  fontSize: 2 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.bold,
                                                  color: MyColors.primaryColor),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 2.5 *
                                                    SizeConfig.widthMultiplier,
                                                right: 2.5 *
                                                    SizeConfig.widthMultiplier),
                                            child: Text(
                                              DateFormat("EEE,MMM-dd").format(
                                                  DateTime.parse(
                                                      transactionDates[index])),
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontUtils.ceraProRegular,
                                                  fontSize: 2 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.bold,
                                                  color: MyColors.primaryColor),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 1.5 * SizeConfig.heightMultiplier),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          child: Container(
                                            width:
                                                27 * SizeConfig.widthMultiplier,
                                            margin: EdgeInsets.only(
                                                left: 2.5 *
                                                    SizeConfig.widthMultiplier,
                                                right: 2.5 *
                                                    SizeConfig.widthMultiplier),
                                            child: Text(
                                              CommonUtils.translate(
                                                  context, "amount"),
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontUtils.ceraProRegular,
                                                  fontSize: 2 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.bold,
                                                  color: MyColors.primaryColor),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                left: 2.5 *
                                                    SizeConfig.widthMultiplier,
                                                right: 2.5 *
                                                    SizeConfig.widthMultiplier,
                                                bottom: 1.5 *
                                                    SizeConfig
                                                        .heightMultiplier),
                                            child: Text(
                                              "${transactionValues[index]['amount']} ${isEnglish ? transactionValues[index]['currency']['en'] : transactionValues[index]['currency']['ar']}",
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontUtils.ceraProRegular,
                                                  fontSize: 2 *
                                                      SizeConfig.textMultiplier,
                                                  fontWeight: FontWeight.bold,
                                                  color: MyColors.dark_blue),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: transactions.length,
                        ),
            )
          ],
        ),
      ),
    );
  }
}
