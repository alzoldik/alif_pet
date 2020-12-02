import 'package:alif_pet/Apis/api_utils.dart';
import 'package:alif_pet/Utils/common_utils.dart';
import 'package:alif_pet/Utils/font_utils.dart';
import 'package:alif_pet/Utils/my_colors.dart';
import 'package:alif_pet/Utils/screen_config.dart';
import 'package:alif_pet/Utils/screen_util.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:alif_pet/Utils/constants.dart';
import 'package:alif_pet/models/profile.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoCall extends StatefulWidget {
  final String callID;

  final Profile user;

  const VideoCall({Key key, this.callID, this.user}) : super(key: key);

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool disableVideo = false;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (Constants.AGORA_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, widget.callID, null, 0);
  }

  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(Constants.AGORA_ID);
    await AgoraRtcEngine.enableVideo();
  }

  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });

    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onToggleStream() {
    setState(() {
      disableVideo = !disableVideo;
    });
    AgoraRtcEngine.muteLocalVideoStream(disableVideo);
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            _viewRows(),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: MyColors.primaryColor.withOpacity(.6),
                height: 18 * SizeConfig.heightMultiplier,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: CommonUtils.getLanguage(context) == "english"
                          ? Alignment.topLeft
                          : Alignment.topRight,
                      child: IconButton(
                        onPressed: () => _onCallEnd(context),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              CommonUtils.translate(context, "video_call"),
                              style: TextStyle(
                                  letterSpacing: -.6,
                                  fontFamily: FontUtils.ceraProMedium,
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            width: 13 * SizeConfig.imageSizeMultiplier,
                            height: 13 * SizeConfig.imageSizeMultiplier,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColors.grey,
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              child: widget.user.photo == null
                                  ? Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 12 * SizeConfig.imageSizeMultiplier,
                                    )
                                  : Image.network(
                                      ApiUtils.BaseApiUrlMain +
                                          widget.user.photo,
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.user.name,
                              style: TextStyle(
                                  fontFamily: FontUtils.ceraProMedium,
                                  fontSize: 2.9 * SizeConfig.textMultiplier,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            child: Text(
                              _users.length > 0
                                  ? CommonUtils.translate(context, "connected")
                                  : CommonUtils.translate(context, "waiting"),
                              style: TextStyle(
                                  letterSpacing: -.6,
                                  fontFamily: FontUtils.ceraProMedium,
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 11.5 * SizeConfig.heightMultiplier,
                width: ScreenUtil.getInstance().width.toDouble(),
                color: MyColors.primaryColor,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          _onToggleMute();
                        },
                        icon: Icon(
                          muted ? Icons.mic_off : Icons.mic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          _onToggleStream();
                        },
                        icon: Icon(
                          !disableVideo ? Icons.videocam : Icons.videocam_off,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          _onSwitchCamera();
                        },
                        icon: Icon(
                          Icons.switch_camera,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  _onCallEnd(context);
                },
                child: Container(
                  margin:
                      EdgeInsets.only(bottom: 17 * SizeConfig.heightMultiplier),
                  height: 12 * SizeConfig.imageSizeMultiplier,
                  width: 12 * SizeConfig.imageSizeMultiplier,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFec192e)),
                  child: Transform.rotate(
                      angle: 2.3,
                      child: Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 5.5 * SizeConfig.imageSizeMultiplier,
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
