import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/models/blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogItem extends StatelessWidget {
  final Blog blog;
  const BlogItem({Key key, this.blog}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2 * SizeConfig.imageSizeMultiplier),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.3),
                  blurRadius: 1.5 * SizeConfig.imageSizeMultiplier,
                  offset: Offset(-2, 0))
            ]),
            child: Column(
              children: <Widget>[
                Container(
                  height: 6 * SizeConfig.heightMultiplier,
                  color: MyColors.right_chat_item_color.withOpacity(.7),
                  child: Center(
                    child: Text(
                      blog.title == null ? "-" : blog.title,
                      style: TextStyle(
                          fontFamily: FontUtils.ceraProMedium,
                          fontSize: 2.0 * SizeConfig.textMultiplier,
                          color: MyColors.primaryColor),
                    ),
                  ),
                ),
                Hero(
                  tag: blog.id,
                  child: Container(
                    height: 25 * SizeConfig.heightMultiplier,
                    width: ScreenUtil.getInstance().width.toDouble(),
                    child: Image.network(
                      ApiUtils.BaseApiUrlMain + blog.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Center(
              child: Text(
                blog.body == null ? "-" : blog.body,
                style: TextStyle(
                    fontFamily: FontUtils.ceraProRegular,
                    fontSize: 1.5 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryColor),
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            child: Center(
              child: Text(
                CommonUtils.translate(context, "read_more") + " ...",
                style: TextStyle(
                    fontFamily: FontUtils.ceraProRegular,
                    fontWeight: FontWeight.bold,
                    fontSize: 1.7 * SizeConfig.textMultiplier,
                    color: MyColors.red.withOpacity(.7)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
