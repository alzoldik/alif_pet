import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/models/review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ClientReviewItem extends StatelessWidget {
  final Review review;
  ClientReviewItem(this.review);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.5 * SizeConfig.heightMultiplier),
      child: Column(
        children: <Widget>[
          Container(
            margin: CommonUtils.getLanguage(context) == "english"
                ? EdgeInsets.only(left: 1.5 * SizeConfig.widthMultiplier)
                : EdgeInsets.only(right: 1.5 * SizeConfig.widthMultiplier),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 3.7 * SizeConfig.imageSizeMultiplier,
                  backgroundImage: AssetImage(ImageUtils.doctorIcon),
                ),
                Container(
                  margin: CommonUtils.getLanguage(context) == "english"
                      ? EdgeInsets.only(left: 1.5 * SizeConfig.widthMultiplier)
                      : EdgeInsets.only(
                          right: 1.5 * SizeConfig.widthMultiplier),
                  child: Text(
                    review.clientId.toString(),
                    style: TextStyle(
                      fontFamily: FontUtils.ceraProMedium,
                      fontSize: 1.8 * SizeConfig.textMultiplier,
                      color: MyColors.primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: CommonUtils.getLanguage(context) == "english"
                ? EdgeInsets.only(
                    top: 1 * SizeConfig.heightMultiplier,
                    left: 1.5 * SizeConfig.widthMultiplier)
                : EdgeInsets.only(
                    top: 1 * SizeConfig.heightMultiplier,
                    right: 1.5 * SizeConfig.widthMultiplier),
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // RatingBar(
                //   ignoreGestures: true,
                //   itemSize: 2.5 * SizeConfig.imageSizeMultiplier,
                //   initialRating: review.rating.toDouble(),
                //   minRating: 0,
                //   direction: Axis.horizontal,
                //   allowHalfRating: true,
                //   itemCount: 5,
                //   itemBuilder: (context, _) => Icon(
                //     Icons.star,
                //     color: MyColors.red,
                //   ),
                //   onRatingUpdate: (rating) {
                //     print(rating);
                //   },
                // ),
                RatingBar.builder(
                  ignoreGestures: true,
                  itemSize: 2.5 * SizeConfig.imageSizeMultiplier,
                  initialRating: review.rating.toDouble(),
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: MyColors.red,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                Container(
                  margin: CommonUtils.getLanguage(context) == "english"
                      ? EdgeInsets.only(left: 1.5 * SizeConfig.widthMultiplier)
                      : EdgeInsets.only(
                          right: 1.5 * SizeConfig.widthMultiplier),
                  child: Text(
                    DateFormat("dd-MM-yy")
                        .format(DateTime.parse(review.createdAt)),
                    style: TextStyle(
                      fontFamily: FontUtils.ceraProMedium,
                      fontSize: 1.5 * SizeConfig.textMultiplier,
                      color: MyColors.primaryColor.withOpacity(.5),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: ScreenUtil.getInstance().width.toDouble(),
            margin: EdgeInsets.only(
                top: 1.5 * SizeConfig.heightMultiplier,
                left: 1.5 * SizeConfig.widthMultiplier,
                right: 4 * SizeConfig.widthMultiplier),
            child: Text(
              review.comment,
              style: TextStyle(
                fontFamily: FontUtils.ceraProMedium,
                fontSize: 1.8 * SizeConfig.textMultiplier,
                color: MyColors.primaryColor,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
