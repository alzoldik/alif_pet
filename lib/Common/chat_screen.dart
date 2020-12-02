import 'dart:async';
import 'dart:io';
import 'package:alif_pet/Common/right_chat_item.dart';
import 'package:alif_pet/Common/video_call.dart';
import 'package:alif_pet/Common/voice_call.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/image_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:alif_pet/Utils/userData.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart' as myPath;
import 'package:permission_handler/permission_handler.dart';
import '../Apis/api_utils.dart';
import '../Apis/common_apis.dart';
import '../Utils/string_utils.dart';
import '../Utils/toast_utils.dart';
import '../models/message.dart';
import '../models/profile.dart';
import 'left_chat_item.dart';
import 'my_loader.dart';

class ChatScreen extends StatefulWidget {
  final int serviceId;
  final Profile userToSend;
  final UserData userData;
  const ChatScreen({Key key, this.serviceId, this.userData, this.userToSend})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  bool isLoading = true,
      isInternet = true,
      isEnglish = true,
      isSending = false,
      isFirstTime = true;
  final ScrollController listController = ScrollController();
  int timerTime = 0;
  List<Message> messages = [];
  Timer timer;
  File _forImage;
  var options;
  FlutterPusher pusher;
  Echo echo;
  String channel;

  @override
  void initState() {
    channel = 'chat.' + widget.serviceId.toString();
    options =
        PusherOptions(host: '52.57.112.216', port: 6001, encrypted: false);
    pusher = FlutterPusher('myKey', options);
    echo = new Echo({
      'broadcaster': 'pusher',
      'client': pusher,
      'auth': {
        'headers': {'Authorization': widget.userData.getToken}
      },
    });

    echo
        .join(channel)
        .here((users) {
          print(users);
        })
        .joining((user) {
          print(user);
        })
        .leaving((user) {
          print(user);
        })
        .listen('MessageSent', (e) => {print(e)})
        .listerForWhisper('typing', (e) => {print(e)});
    pusher.connect(onConnectionStateChange: this.onConnectionStateChange);
    pusher.subscribe(channel).bind('MessageSent', (event) => {print(event)});
    /* pusher.subscribe('chat.'+widget.serviceId.toString()).bind("MessageSent", (e){
      print(e);
    });*/
    CommonUtils.checkInternet().then((value) {
      if (value) {
        CommonApis().getMessages(
            {"service_request_id": widget.serviceId}, isEnglish).then((result) {
          if (result is String) {
          } else {
            messages = result;
            isLoading = false;
            if (mounted) {
              setState(() {});
            }
          }
        });
      } else {
        if (mounted) {
          setState(() {
            isInternet = false;
          });
        }
      }
    });
    /*timer = new Timer.periodic(Duration(milliseconds: 3000), (timer){

    });*/
    Future.delayed(Duration(milliseconds: 90)).then((done) {
      FlutterStatusbarcolor.setStatusBarColor(MyColors.primaryColor);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    });
    super.initState();
  }

  void onConnectionStateChange(ConnectionStateChange event) {
    if (event.currentState == 'CONNECTED') {
      print('connected');
      if (mounted) {
        setState(() {
          //  is_connected = false;
        });
      }
    } else if (event.currentState == 'DISCONNECTED') {
      print('disconnected');
      if (mounted) {
        setState(() {
          //  is_connected = false;
        });
      }
    }
  }

  @override
  void dispose() {
    listController.dispose();
    //timer.cancel();
    pusher.disconnect();
    messageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    isEnglish = CommonUtils.getLanguage(context) == "english";
    super.didChangeDependencies();
  }

  void pickImageAndSend() async {
    File selected = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _forImage = selected;
    });
    if (_forImage != null) {
      CommonUtils.checkInternet().then((value) async {
        if (value) {
          isSending = true;
          setState(() {});
          FormData formData = FormData.fromMap(({
            "service_request_id": widget.serviceId,
            "type": "image",
            "file": await MultipartFile.fromFile(_forImage.path,
                filename: myPath.basename(_forImage.path))
          }));
          CommonApis().sendMessage(formData, isEnglish).then((result) {
            if (result is String) {
              ToastUtils.showCustomToast(
                  context, result, Colors.white, MyColors.primaryColor);
            } else {
              isSending = false;
              setState(() {});
              /*   messages = result;
              isLoading = false;
              setState(() {});*/
            }
          });
        } else {
          setState(() {
            isInternet = false;
            ToastUtils.showCustomToast(context, StringUtils.noInternet,
                Colors.white, MyColors.primaryColor);
          });
        }
      });
    }
  }

  void pickImageFromCameraAndSend() async {
    File selected = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _forImage = selected;
    });
    if (_forImage != null) {
      CommonUtils.checkInternet().then((value) async {
        if (value) {
          isSending = true;
          setState(() {});
          FormData formData = FormData.fromMap(({
            "service_request_id": widget.serviceId,
            "type": "image",
            "file": await MultipartFile.fromFile(_forImage.path,
                filename: myPath.basename(_forImage.path))
          }));
          CommonApis().sendMessage(formData, isEnglish).then((result) {
            if (result is String) {
              ToastUtils.showCustomToast(
                  context, result, Colors.white, MyColors.primaryColor);
            } else {
              isSending = false;
              setState(() {});
              /*   messages = result;
              isLoading = false;
              setState(() {});*/
            }
          });
        } else {
          setState(() {
            isInternet = false;
            ToastUtils.showCustomToast(context, StringUtils.noInternet,
                Colors.white, MyColors.primaryColor);
          });
        }
      });
    }
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      CommonUtils.checkInternet().then((value) {
        if (value) {
          isSending = true;
          setState(() {});
          CommonApis().sendMessage({
            "service_request_id": widget.serviceId,
            "type": "text",
            "message": messageController.text
          }, isEnglish).then((result) {
            if (result is String) {
              ToastUtils.showCustomToast(
                  context, result, Colors.white, MyColors.primaryColor);
            } else {
              messageController.clear();
              isSending = false;
              setState(() {});
            }
          });
        } else {
          setState(() {
            isInternet = false;
            ToastUtils.showCustomToast(context, StringUtils.noInternet,
                Colors.white, MyColors.primaryColor);
          });
        }
      });
    }
  }

/*  void pickFileAndSend() async{
    File selected = await FilePicker.getFile(fileExtension: "pdf",type: FileType.custom);
    setState(() {
      _documment = selected;
    });
    if(_documment!=null){
      CommonUtils.checkInternet().then((value) async{
        if(value){
          isSending = true;
          setState(() {});
          FormData formData = FormData.fromMap(({"service_request_id" : widget.serviceId,"type":"document","file" : await MultipartFile.fromFile(_documment.path,filename: myPath.basename(_documment.path)) }));
          CommonApis().sendMessage(formData,isEnglish).then((result){
            if(result is String){
              ToastUtils.showCustomToast(context, result, Colors.white , MyColors.primaryColor);
            }
            else{
              isSending = false;
              setState(() {});
              */ /*   messages = result;
              isLoading = false;
              setState(() {});*/ /*
            }
          });
        }
        else{
          setState(() {
            isInternet = false;
            ToastUtils.showCustomToast(context, StringUtils.noInternet , Colors.white , MyColors.primaryColor);
          });
        }
      });
    }
  }*/
  // ignore: missing_return
  Future<bool> goBack() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: goBack,
      child: SafeArea(
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
                  height: 10,
                  color: MyColors.primaryColor,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  color: MyColors.primaryColor,
                  margin: EdgeInsets.only(top: 10.0),
                  height: 7.5 * SizeConfig.heightMultiplier,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: CommonUtils.getLanguage(context) == "english"
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: IconButton(
                          onPressed: goBack,
                          icon: Icon(
                            Icons.keyboard_backspace,
                            color: Colors.white,
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
                          tag: widget.serviceId,
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              width: 8.5 * SizeConfig.imageSizeMultiplier,
                              height: 8.5 * SizeConfig.imageSizeMultiplier,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                child: widget.userToSend.photo == null
                                    ? Image.asset(
                                        ImageUtils.doctorIcon,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.network(
                                        ApiUtils.BaseApiUrlMain +
                                            widget.userToSend.photo,
                                        fit: BoxFit.contain,
                                      ),
                              ),
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
                          widget.userToSend.name,
                          style: TextStyle(
                              fontFamily: FontUtils.ceraProBold,
                              fontSize: 2.9 * SizeConfig.textMultiplier,
                              color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: CommonUtils.getLanguage(context) == "english"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: InkWell(
                            onTap: () {
                              _handleCameraAndMic();
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: VideoCall(
                                        callID: widget.serviceId.toString(),
                                        user: widget.userToSend,
                                      )));
                            },
                            child: Container(
                              margin: CommonUtils.getLanguage(context) ==
                                      "english"
                                  ? EdgeInsets.only(
                                      right: 12 * SizeConfig.widthMultiplier)
                                  : EdgeInsets.only(
                                      left: 12 * SizeConfig.widthMultiplier),
                              child: Icon(Icons.videocam,
                                  color: Colors.white,
                                  size: 6 * SizeConfig.imageSizeMultiplier),
                            )),
                      ),
                      Align(
                        alignment: CommonUtils.getLanguage(context) == "english"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: VoiceCall(
                                        callID: widget.serviceId.toString(),
                                        user: widget.userToSend,
                                      )));
                            },
                            child: Container(
                              margin: CommonUtils.getLanguage(context) ==
                                      "english"
                                  ? EdgeInsets.only(
                                      right: 2.5 * SizeConfig.widthMultiplier)
                                  : EdgeInsets.only(
                                      left: 2.5 * SizeConfig.widthMultiplier),
                              child: Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 5.5 * SizeConfig.imageSizeMultiplier,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: isLoading
                    ? MyLoader()
                    : Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.symmetric(
                            vertical: 9.4 * SizeConfig.heightMultiplier,
                            horizontal: 2.5 * SizeConfig.widthMultiplier),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return widget.userData.getUserType ==
                                    messages[index].user.roleName
                                ? RightChatItem(message: messages[index])
                                : LeftChatItem(message: messages[index]);
                          },
                          itemCount: messages.length,
                          controller: listController,
                          reverse: true,
                        ),
                      ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 9 * SizeConfig.heightMultiplier,
                  width: ScreenUtil.getInstance().width.toDouble(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: Container(
                          margin: CommonUtils.getLanguage(context) == "english"
                              ? EdgeInsets.only(
                                  left: 3.5 * SizeConfig.widthMultiplier,
                                  bottom: 2 * SizeConfig.heightMultiplier)
                              : EdgeInsets.only(
                                  right: 3.5 * SizeConfig.widthMultiplier,
                                  bottom: 2 * SizeConfig.heightMultiplier),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: MyColors.chat_message_color,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(.4),
                                    blurRadius:
                                        4.5 * SizeConfig.imageSizeMultiplier,
                                    spreadRadius: 0.0),
                              ]),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 8,
                                child: TextFormField(
                                  onTap: () {
                                    /*      listController.animateTo(
                                     0.0,
                                     curve: Curves.easeOut,
                                     duration: const Duration(milliseconds: 300),
                                   );*/
                                  },
                                  controller: messageController,
                                  cursorColor: MyColors.primaryColor,
                                  textAlign: TextAlign.start,
                                  autofocus: false,
                                  style: TextStyle(
                                    fontSize: 2.2 * SizeConfig.textMultiplier,
                                    fontFamily: FontUtils.ceraProMedium,
                                    color: MyColors.primaryColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: CommonUtils.translate(
                                        context, "type_a_message"),
                                    hintStyle: TextStyle(
                                      fontSize: 2.2 * SizeConfig.textMultiplier,
                                      fontFamily: FontUtils.ceraProMedium,
                                      color:
                                          MyColors.primaryColor.withOpacity(.5),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical:
                                            1.0 * SizeConfig.heightMultiplier,
                                        horizontal:
                                            3.0 * SizeConfig.widthMultiplier),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: pickImageAndSend,
                                        child: Container(
                                          margin: CommonUtils.getLanguage(
                                                      context) ==
                                                  "english"
                                              ? EdgeInsets.only(
                                                  right: 1 *
                                                      SizeConfig
                                                          .widthMultiplier)
                                              : EdgeInsets.only(
                                                  left: 1 *
                                                      SizeConfig
                                                          .widthMultiplier),
                                          child: Transform.rotate(
                                              angle: 5.5,
                                              child: Icon(Icons.attachment,
                                                  size: 5.5 *
                                                      SizeConfig
                                                          .imageSizeMultiplier,
                                                  color: MyColors.primaryColor
                                                      .withOpacity(.5))),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: pickImageFromCameraAndSend,
                                        child: Container(
                                          margin: CommonUtils.getLanguage(
                                                      context) ==
                                                  "english"
                                              ? EdgeInsets.only(
                                                  right: 1 *
                                                      SizeConfig
                                                          .widthMultiplier)
                                              : EdgeInsets.only(
                                                  left: 1 *
                                                      SizeConfig
                                                          .widthMultiplier),
                                          child: Icon(Icons.camera_alt,
                                              size: 5.5 *
                                                  SizeConfig
                                                      .imageSizeMultiplier,
                                              color: MyColors.primaryColor
                                                  .withOpacity(.5)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: isSending ? null : sendMessage,
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: 2 * SizeConfig.imageSizeMultiplier,
                                  right: 2 * SizeConfig.imageSizeMultiplier,
                                  bottom: 4 * SizeConfig.imageSizeMultiplier),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSending
                                    ? Colors.grey.withOpacity(.8)
                                    : Colors.black.withOpacity(.8),
                              ),
                              // child: Icon(Icons.keyboard_voice,color: Colors.white,)
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
