import 'package:flutter/material.dart';

import '../../core/resources/style.dart';

Widget backBtn(void Function() onPressed) {
  return IconButton(
    onPressed: onPressed,
    icon: const Icon(
      Icons.arrow_back_ios_outlined,
      color: AppStyle.neutralColor400,
    ),
  );
}

Widget closeBtn(void Function() onPressed) {
  return TextButton(
    onPressed: onPressed,
    child: Text("Close", style: AppStyle.bodyText()),
  );
}