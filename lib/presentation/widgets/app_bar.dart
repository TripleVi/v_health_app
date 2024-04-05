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
      foregroundColor: AppStyle.secondaryIconColor,
      leading: leading,
      centerTitle: true,
      title: Text(title, style: AppStyle.heading3()),
    );
  }
}
