// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../core/utilities/constants.dart';
import 'Text.dart';

class CustomAppBar {
  static AppBar get({
    required String title,
    Widget? leading,
    List<Widget>? actions,
  }) {
    return AppBar(
      actions: actions,
      backgroundColor: Colors.white,
      foregroundColor: Constants.primaryColor,
      elevation: 0,
      leading: leading,
      centerTitle: true,
      title: TextTypes.heading_1(content: title, color: Constants.primaryColor),
    );
  }
}
