import 'dart:ui';

import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Apis/client_apis.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/Utils/string_utils.dart';
import 'package:alif_pet/Utils/toast_utils.dart';
import 'package:alif_pet/models/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewDialog extends StatefulWidget {
  final String serviceId;
  final Profile doctor;

  const ReviewDialog({Key key, this.serviceId, this.doctor}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReviewDialogState();
  }
}

class ReviewDialogState extends State<ReviewDialog> {
  var textCounter = "0/500";
  bool isRating = false;
  num rating = 1;
  final commentController = TextEditingController();

  void rateDoctor() {
    if (commentController.text.length > 0) {
      CommonUtils.checkInternet().then((value) {
        if (value) {
          isRating = true;
          setState(() {});
          ClientApis().rateDoctor({
            "service_request_id": int.parse(widget.serviceId),
            "doctor_id": widget.doctor.id,
            "rating": rating.round(),
            "comment": commentController.text
          }, CommonUtils.getLanguage(context) == "english").then((result) {
            if (result is String) {
              isRating = false;
              ToastUtils.showCustomToast(
                  context, result, Colors.white, MyColors.primaryColor);
              setState(() {});
            } else if (result is bool && result) {
              isRating = false;
              ToastUtils.showCustomToast(
                  context,
                  CommonUtils.translate(context, "success_on_rating"),
                  Colors.white,
                  MyColors.primaryColor);
              Navigator.pop(context);
              Navigator.of(context).pop(true);
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
          CommonUtils.translate(context, "give_comment"),
          Colors.white,
          MyColors.primaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context),
      ),
    );
  }

  Widget dialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.5),
                      blurRadius: 2 * SizeConfig.imageSizeMultiplier)
                ]),
            margin: EdgeInsets.all(2.5 * SizeConfig.imageSizeMultiplier),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: ScreenUtil.getInstance().width.toDouble(),
                  margin: CommonUtils.getLanguage(context) == "english"
                      ? EdgeInsets.only(
                          left: 3.5 * SizeConfig.widthMultiplier,
                          top: 3.5 * SizeConfig.heightMultiplier)
                      : EdgeInsets.only(
                          right: 3.5 * SizeConfig.widthMultiplier,
                          top: 3.5 * SizeConfig.heightMultiplier),
                  child: Text(
                      CommonUtils.translate(context, 'review_dialog_title'),
                      style: TextStyle(
                        fontSize: 2.5 * SizeConfig.textMultiplier,
                        fontFamily: FontUtils.ceraProMedium,
                        color: MyColors.primaryColor,
                      )),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 3 * SizeConfig.heightMultiplier,
                      horizontal: 3.5 * SizeConfig.widthMultiplier),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Hero(
                        tag: widget.serviceId,
                        child: Container(
                          width: 11 * SizeConfig.imageSizeMultiplier,
                          height: 11 * SizeConfig.imageSizeMultiplier,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(.5),
                                    offset: Offset(0, 1.5),
                                    blurRadius:
                                        2.5 * SizeConfig.imageSizeMultiplier)
                              ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: widget.doctor.photo == null
                                ? Image.asset(
                                    ImageUtils.doctorIcon,
                                    fit: BoxFit.contain,
                                  )
                                : Image.network(
                                    ApiUtils.BaseApiUrlMain +
                                        widget.doctor.photo,
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        margin: CommonUtils.getLanguage(context) == "english"
                            ? EdgeInsets.only(
                                left: 3.5 * SizeConfig.widthMultiplier)
                            : EdgeInsets.only(
                                right: 3.5 * SizeConfig.widthMultiplier),
                        child: Text(widget.doctor.name,
                            style: TextStyle(
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                              fontFamily: FontUtils.ceraProMedium,
                              color: MyColors.primaryColor,
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      right: 2.5 * SizeConfig.widthMultiplier,
                      left: 2.5 * SizeConfig.widthMultiplier),
                  child: RatingBar(
                    itemSize: 8 * SizeConfig.imageSizeMultiplier,
                    initialRating: 1,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                      full: Icon(Icons.star, color: MyColors.primaryColor),
                      half: Icon(Icons.star_half, color: MyColors.primaryColor),
                      empty: Icon(
                        Icons.star_border,
                        color: MyColors.primaryColor.withOpacity(.6),
                      ),
                    ),
                    /*      itemBuilder: (context, _) => Icon(
                  Icons.star_border,
                  color: MyColors.primaryColor,
                ),*/
                    onRatingUpdate: (rating) {
                      this.rating = rating;
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 3.5 * SizeConfig.widthMultiplier,
                      vertical: 3.7 * SizeConfig.heightMultiplier),
                  width: ScreenUtil.getInstance().width.toDouble(),
                  height: 20 * SizeConfig.heightMultiplier,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                          Radius.circular(3 * SizeConfig.imageSizeMultiplier)),
                      border: Border.all(color: MyColors.grey, width: 1)),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            bottom: 3 * SizeConfig.heightMultiplier),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              textCounter = value.length.toString() + "/500";
                            });
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 500,
                          textAlign: TextAlign.start,
                          controller: commentController,
                          cursorColor: MyColors.primaryColor,
                          autofocus: false,
                          style: TextStyle(
                            fontSize: 2.2 * SizeConfig.textMultiplier,
                            fontFamily: FontUtils.ceraProMedium,
                            color: MyColors.primaryColor,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: CommonUtils.translate(
                                context, "describe_your_experience"),
                            hintStyle: TextStyle(
                              fontSize: 2.2 * SizeConfig.textMultiplier,
                              fontFamily: FontUtils.ceraProMedium,
                              color: MyColors.primaryColor.withOpacity(.5),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 1.5 * SizeConfig.heightMultiplier,
                                horizontal: 3.0 * SizeConfig.widthMultiplier),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: CommonUtils.getLanguage(context) == "english"
                            ? Alignment.bottomRight
                            : Alignment.bottomLeft,
                        margin: CommonUtils.getLanguage(context) == "english"
                            ? EdgeInsets.only(
                                bottom: 1 * SizeConfig.heightMultiplier,
                                right: 1 * SizeConfig.widthMultiplier)
                            : EdgeInsets.only(
                                bottom: 1 * SizeConfig.heightMultiplier,
                                left: 1 * SizeConfig.widthMultiplier),
                        child: Text(
                          textCounter,
                          style: TextStyle(
                            fontSize: 1.8 * SizeConfig.textMultiplier,
                            fontFamily: FontUtils.ceraProRegular,
                            color: MyColors.primaryColor.withOpacity(.5),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 1.5 * SizeConfig.heightMultiplier,
                      bottom: 3 * SizeConfig.heightMultiplier),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(
                              right:
                                  CommonUtils.getLanguage(context) != "english"
                                      ? 6.5 * SizeConfig.widthMultiplier
                                      : 3.5 * SizeConfig.widthMultiplier,
                              left:
                                  CommonUtils.getLanguage(context) != "english"
                                      ? 3.5 * SizeConfig.widthMultiplier
                                      : 6.5 * SizeConfig.widthMultiplier),
                          child: MaterialButton(
                            child: Text(CommonUtils.translate(context, "send"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 2.3 * SizeConfig.textMultiplier,
                                    fontFamily: FontUtils.ceraProRegular)),
                            onPressed: isRating
                                ? null
                                : () {
                                    rateDoctor();
                                  },
                            height: 5 * SizeConfig.heightMultiplier,
                            minWidth: double.infinity,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    2.8 * SizeConfig.imageSizeMultiplier),
                              ),
                            ),
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
                              right:
                                  CommonUtils.getLanguage(context) == "english"
                                      ? 6.5 * SizeConfig.widthMultiplier
                                      : 3.5 * SizeConfig.widthMultiplier,
                              left:
                                  CommonUtils.getLanguage(context) == "english"
                                      ? 3.5 * SizeConfig.widthMultiplier
                                      : 6.5 * SizeConfig.widthMultiplier),
                          child: MaterialButton(
                            child: Text(
                                CommonUtils.translate(context, "cancel"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 2.3 * SizeConfig.textMultiplier,
                                    fontFamily: FontUtils.ceraProRegular)),
                            onPressed: isRating
                                ? null
                                : () {
                                    Navigator.pop(context);
                                  },
                            height: 5 * SizeConfig.heightMultiplier,
                            minWidth: double.infinity,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    2.8 * SizeConfig.imageSizeMultiplier))),
                            color: MyColors.primaryColor,
                            elevation: 0.0,
                            highlightElevation: 0.0,
                            disabledColor:
                                MyColors.primaryColor.withOpacity(.8),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: isRating
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
              child: Container(
                width: 7 * SizeConfig.imageSizeMultiplier,
                height: 7 * SizeConfig.imageSizeMultiplier,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.grey,
                ),
                child: Icon(
                  Icons.clear,
                  color: Colors.black,
                  size: 6 * SizeConfig.imageSizeMultiplier,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
