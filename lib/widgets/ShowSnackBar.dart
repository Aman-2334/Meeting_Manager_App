import 'package:flutter/material.dart';

class ShowSnackBar {

  ScaffoldFeatureController showSnackBar(ctx, text) {
    return ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      margin: EdgeInsets.all(5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      duration: Duration(seconds: 1),
      content: Text(text),
      backgroundColor: Colors.black,
    ));
  }
}
