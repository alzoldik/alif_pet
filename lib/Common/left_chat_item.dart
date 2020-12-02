import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/index.dart';

class LeftChatItem extends StatelessWidget {
  final Message message;
  const LeftChatItem({Key key, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(
              maxWidth: message.type == "document"
                  ? ScreenUtil.getInstance().width * .45
                  : ScreenUtil.getInstance().width * .65,
              maxHeight: message.type == "document"
                  ? 15 * SizeConfig.heightMultiplier
                  : 30 * SizeConfig.heightMultiplier),
          margin: EdgeInsets.only(
              left: 1.5 * SizeConfig.widthMultiplier,
              bottom: 2.5 * SizeConfig.heightMultiplier),
          padding: message.type != "image"
              ? EdgeInsets.only(
                  left: message.type == "document"
                      ? 0
                      : 2.5 * SizeConfig.imageSizeMultiplier,
                  right: message.type == "document"
                      ? 0
                      : 2.5 * SizeConfig.imageSizeMultiplier,
                  bottom: message.type == "document"
                      ? 0
                      : 2 * SizeConfig.heightMultiplier,
                  top: 2 * SizeConfig.heightMultiplier)
              : null,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(
                  Radius.circular(3.5 * SizeConfig.imageSizeMultiplier)),
              color: MyColors.left_chat_item_color,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 2 * SizeConfig.imageSizeMultiplier,
                    spreadRadius: 0.0,
                    offset: Offset(0, 1)),
              ]),
          child: message.type == "text"
              ? Text(
                  message.message == null ? "" : message.message,
                  style: TextStyle(
                      fontFamily: FontUtils.ceraProBold,
                      fontSize: 1.9 * SizeConfig.textMultiplier,
                      color: MyColors.primaryColor),
                )
              : message.type == "image"
                  ? Padding(
                      padding: EdgeInsets.all(3),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(
                              3 * SizeConfig.imageSizeMultiplier)),
                          child: Image.network(
                            ApiUtils.BaseApiUrlMain + message.file,
                            fit: BoxFit.contain,
                          )))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              right: 2.5 * SizeConfig.imageSizeMultiplier,
                              left: 2.5 * SizeConfig.imageSizeMultiplier),
                          child: Text(
                            message.file == null
                                ? ""
                                : message.file
                                    .substring(5, message.file.length),
                            style: TextStyle(
                                fontFamily: FontUtils.ceraProBold,
                                fontSize: 1.9 * SizeConfig.textMultiplier,
                                color: MyColors.primaryColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: ScreenUtil.getInstance().width.toDouble(),
                          height: 5 * SizeConfig.heightMultiplier,
                          child: Icon(
                            Icons.file_download,
                            color: Colors.white,
                            size: 7 * SizeConfig.imageSizeMultiplier,
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      3 * SizeConfig.imageSizeMultiplier),
                                  bottomRight: Radius.circular(
                                      3 * SizeConfig.imageSizeMultiplier))),
                        )
                      ],
                    ),
        ),
      ],
    );
  }
}
