import 'dart:async';

import 'package:alif_pet/Common/my_loader.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AddBalanceScreen extends StatefulWidget {
  final String amount;
  final String clientId;
  AddBalanceScreen(this.amount, this.clientId);
  @override
  _AddBalanceScreenState createState() => _AddBalanceScreenState();
}

class _AddBalanceScreenState extends State<AddBalanceScreen> {
  bool isLoading = true;
  String paymentWindowScript;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
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
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 10.0),
                height: 7.5 * SizeConfig.heightMultiplier,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context, true);
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
                        CommonUtils.translate(context, "add_balance"),
                        style: TextStyle(
                            fontFamily: FontUtils.ceraProBold,
                            fontSize: 2.9 * SizeConfig.textMultiplier,
                            color: MyColors.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              margin: CommonUtils.getLanguage(context) == "english"
                  ? EdgeInsets.only(
                      left: 3 * SizeConfig.widthMultiplier,
                      top: 12 * SizeConfig.heightMultiplier)
                  : EdgeInsets.only(
                      right: 3 * SizeConfig.widthMultiplier,
                      top: 12 * SizeConfig.heightMultiplier),
              child: Builder(builder: (BuildContext context) {
                return WebView(
                  initialUrl:
                      'https://app.alifpet.com/public/api/get_payment_window/1/${widget.clientId}/${widget.amount}',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  onWebResourceError: (error) {
                    print(error.description);
                    //Navigator.pop(context,true);
                  },
                  onPageStarted: (String url) {
                    print('Page started loading: $url');
                  },
                  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                    isLoading = false;
                    setState(() {});
                  },
                  gestureNavigationEnabled: true,
                );
              }),
            ),
            isLoading
                ? Center(
                    child: MyLoader(),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
