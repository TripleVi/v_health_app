import 'package:flutter/material.dart';

import '../../core/resources/colors.dart';
import '../../core/resources/style.dart';

Widget backBtn(void Function() onPressed) {
  return IconButton(
    onPressed: onPressed,
    icon: Icon(
      Icons.arrow_back_ios_outlined,
      color: AppColor.onBackgroundColor,
    ),
  );
}

Widget closeBtn(void Function() onPressed) {
  return TextButton(
    onPressed: onPressed,
    child: Text("Close", style: AppStyle.paragraph()),
  );
}