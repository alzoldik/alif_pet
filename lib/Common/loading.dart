import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoadingState();
  }
}

class LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(.5),
    );
  }
}
