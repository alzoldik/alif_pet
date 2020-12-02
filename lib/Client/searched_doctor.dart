import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/models/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SearchedDoctor extends StatelessWidget {
  final Profile doctor;
  const SearchedDoctor({Key key, this.doctor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Hero(
          tag: doctor.id,
          child: Container(
            height: 27 * SizeConfig.imageSizeMultiplier,
            width: 27 * SizeConfig.imageSizeMultiplier,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(.5),
                      blurRadius: 2 * SizeConfig.imageSizeMultiplier,
                      spreadRadius: 0.0,
                      offset: Offset(0, 3.5)),
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              child: doctor.photo == null
                  ? Image.asset(
                      ImageUtils.doctorIcon,
                      fit: BoxFit.contain,
                    )
                  : Image.network(
                      ApiUtils.BaseApiUrlMain + doctor.photo,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: 2.5 * SizeConfig.heightMultiplier,
              left: 2.5 * SizeConfig.widthMultiplier,
              right: 2.5 * SizeConfig.widthMultiplier),
          alignment: Alignment.topCenter,
          child: Text(
            doctor.name == null ? "-" : doctor.name,
            style: TextStyle(
              fontFamily: FontUtils.ceraProBold,
              fontSize: 1.8 * SizeConfig.textMultiplier,
              color: MyColors.primaryColor,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: 1 * SizeConfig.heightMultiplier,
              left: 2.5 * SizeConfig.widthMultiplier,
              right: 2.5 * SizeConfig.widthMultiplier),
          alignment: Alignment.topCenter,
          child: Text(
            doctor.speciality == null
                ? "-"
                : CommonUtils.getLanguage(context) == "english"
                    ? doctor.speciality.name
                    : doctor.speciality.nameAr,
            style: TextStyle(
              fontFamily: FontUtils.ceraProMedium,
              fontSize: 1.8 * SizeConfig.textMultiplier,
              color: MyColors.primaryColor,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: 1 * SizeConfig.heightMultiplier,
              left: 2.5 * SizeConfig.widthMultiplier,
              right: 2.5 * SizeConfig.widthMultiplier),
          alignment: Alignment.topCenter,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // RatingBar(
              //   ignoreGestures: true,
              //   itemSize: 2.5*SizeConfig.imageSizeMultiplier,
              //   initialRating: doctor.rating==null?0:doctor.rating.toDouble(),
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
                initialRating:
                    doctor.rating == null ? 0 : doctor.rating.toDouble(),
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
                    : EdgeInsets.only(right: 1.5 * SizeConfig.widthMultiplier),
                child: Text(
                  doctor.rating == null ? "(${0}" : "(${doctor.rating})",
                  style: TextStyle(
                    fontFamily: FontUtils.ceraProMedium,
                    fontSize: 1.8 * SizeConfig.textMultiplier,
                    color: MyColors.primaryColor,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
