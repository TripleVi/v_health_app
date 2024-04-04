import 'package:flutter/material.dart';

import '../../core/resources/style.dart';

class CustomAppBar {
  static AppBar get({
    required String title,
    Widget? leading,
    List<Widget>? actions,
  }) {
    return AppBar(
      actions: actions,
      backgroundColor: AppStyle.surfaceColor,
      foregroundColor: AppStyle.textColor,
      elevation: 0,
      leading: leading,
      centerTitle: true,
      title: Text(title, style: AppStyle.heading3()),
    );
  }
}
