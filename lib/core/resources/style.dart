import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class AppStyle {
  static const primaryColor = Color(0xFFEB6440);
  static const onPrimaryColor = Colors.white;
  static const textColor = Color(0xff434242);
  static const labelColor = Color(0xff7D7D7D);
  static const backgroundColor = Colors.white;
  static final onBackgroundColor = Colors.grey.shade300;
  static final dropShadowColor = Colors.grey.shade400;
  static final controlNormalColor = Colors.grey.shade300;
  static const controlActivatedColor = Color(0xff434242);
  static const dangerColor = Colors.red;

  static const fontFace = 'NeueHass';
  static const letterSpacing = 0.5;
  static const lineHeight = 1.4;

  static const horizontalPadding = 8.0;
  static const borderRadius = 12.0;

  AppStyle._();

  static TextStyle heading1({
    String fontFamily = fontFace,
    double fontSize = 32.0,
    Color color = textColor,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = letterSpacing,
    double height = lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle heading2({
    String fontFamily = fontFace,
    double fontSize = 28.0,
    Color color = textColor,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = letterSpacing,
    double height = lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle heading3({
    String fontFamily = fontFace,
    double fontSize = 24.0,
    Color color = textColor,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = letterSpacing,
    double height = lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle heading4({
    String fontFamily = fontFace,
    double fontSize = 20.0,
    Color color = textColor,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = letterSpacing,
    double height = lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle heading5({
    String fontFamily = fontFace,
    double fontSize = 18.0,
    Color color = textColor,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = letterSpacing,
    double height = lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle heading6({
    String fontFamily = fontFace,
    double fontSize = 16.0,
    Color color = textColor,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = letterSpacing,
    double height = lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle heading_1({
    String fontFamily = Constants.fontFace,
    double fontSize = Constants.heading_1_size,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = Constants.letter_spacing,
    double height = Constants.line_height,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle heading_2({
    String fontFamily = Constants.fontFace,
    double fontSize = Constants.heading_2_size,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = Constants.letter_spacing,
    double height = Constants.line_height,
    Color color = Constants.textColor,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle heading_3({
    String fontFamily = Constants.fontFace,
    double fontSize = Constants.heading_3_size,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = Constants.letter_spacing,
    double height = Constants.line_height,
    Color color = Constants.textColor,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle paragraph({
    String fontFamily = fontFace,
    double fontSize = 14.0,
    Color color = textColor,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = letterSpacing,
    double height = lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle label1({
    String fontFamily = fontFace,
    double fontSize = 30.0,
    Color color = labelColor,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = letterSpacing,
    double height = lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle label2({
    String fontFamily = fontFace,
    double fontSize = 26.0,
    Color color = labelColor,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = letterSpacing,
    double height = lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle label3({
    String fontFamily = fontFace,
    double fontSize = 22.0,
    Color color = labelColor,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = letterSpacing,
    double height = lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle label4({
    String fontFamily = fontFace,
    double fontSize = 18.0,
    Color color = labelColor,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = letterSpacing,
    double height = lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle label5({
    String fontFamily = fontFace,
    double fontSize = 16.0,
    Color color = labelColor,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = letterSpacing,
    double height = lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  static TextStyle label6({
    String fontFamily = fontFace,
    double fontSize = 14.0,
    Color color = labelColor,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = letterSpacing,
    double height = lineHeight,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }
}

