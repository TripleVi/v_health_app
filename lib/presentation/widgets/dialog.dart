import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/resources/style.dart';
import '../../core/utilities/utils.dart';

class MyDialog {
  MyDialog._();

  static Future<bool?> displayCupertinoDialog(BuildContext context, String title, String content, {String noBtnLabel = "No", String yesBtnLabel = "Yes"}) {
    return showCupertinoDialog<bool>(
      context: context, 
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            child: Text(noBtnLabel),
            onPressed: () => Navigator.pop<bool>(context, false),
          ),
          CupertinoDialogAction(
            child: Text(yesBtnLabel),
            onPressed: () => Navigator.pop<bool>(context, true),
          ),
        ],
      )
    );
  }

  static Future<bool?> showTwoOptionsDialog({
    required BuildContext context,
    required String title, 
    required String message,
    String yesButtonName = "OK",
    String noButtonName = "CANCEL",
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        MyUtils.closeKeyboard(context);
        return AlertDialog(
          title: Text(title, style: AppStyle.heading3()),
          content: Text(message, style: AppStyle.bodyText()),
          actions: [
            TextButton(
              style: TextButton
                  .styleFrom(foregroundColor: AppStyle.secondaryTextColor),
              onPressed: () => Navigator.pop<bool>(context, false),
              child: Text(noButtonName),
            ),
            TextButton(
              onPressed: () => Navigator.pop<bool>(context, true),
              child: Text(yesButtonName),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showSingleOptionsDialog({
    required BuildContext context,
    required String title, 
    required String message,
    String yesButtonName = "OK",
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        MyUtils.closeKeyboard(context);
        return AlertDialog(
          title: Text(title, style: AppStyle.heading2(height: 1.0)),
          content: Text(message, style: AppStyle.bodyText()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop<void>(context),
              child: Text(
                yesButtonName,
                style: AppStyle.caption2(
                  color: Colors.blue,
                  height: 1.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}