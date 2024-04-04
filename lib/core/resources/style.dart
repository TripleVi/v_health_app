import 'package:flutter/material.dart';

class AppStyle {
  static final dropShadowColor = Colors.grey.shade400;
  static final controlNormalColor = Colors.grey.shade300;
  static const controlActivatedColor = Color(0xff434242);
  
  static const textColor = Color(0xff1d1d1f);
  static const surfaceColor = Colors.white;
  static const primaryColor50 = Color(0xfff8ebea);
  static const primaryColor100 = Color(0xfffad0c4);
  static const primaryColor200 = Color(0xfff8b29f);
  static const primaryColor300 = Color(0xfff6957a);
  static const primaryColor400 = Color(0xfff67f5d);
  static const primaryColor500 = Color(0xfff66b44);
  static const primaryColor = Color(0xffeb6440);
  static const primaryColor700 = Color(0xffdd5e3b);
  static const primaryColor800 = Color(0xffce5838);
  static const primaryColor900 = Color(0xffb24e32);
  static const neutralColor50 = Color(0xfffafafa);
  static const neutralColor = Color(0xfff5f5f5);
  static const neutralColor200 = Color(0xffeeeeee);
  static const neutralColor300 = Color(0xffe0e0e0);
  static const neutralColor400 = Color(0xffbdbdbd);
  static const neutralColor500 = Color(0xff9e9e9e);
  static const neutralColor600 = Color(0xff757575);
  static const neutralColor700 = Color(0xff616161);
  static const neutralColor800 = Color(0xff424242);
  static const neutralColor900 = Color(0xff212121);
  static const onPrimaryColor = Colors.white;
  static const stepColor = Color(0xff59d5e0);
  static const timeColor = Color(0xfff4538a);
  static const calorieColor = Color(0xfff67f5d);

  static const fontFace = 'NeueHass';
  static const letterSpacing = 0.5;
  static const headingLineHeight = 1.15;
  static const bodyLineHeight = 1.4;

  static const horizontalPadding = 8.0;
  static const borderRadius = 12.0;

  AppStyle._();

  static TextStyle heading1({
    String fontFamily = fontFace,
    double fontSize = 32.0,
    Color color = textColor,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = letterSpacing,
    double height = headingLineHeight,
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
    double height = headingLineHeight,
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
    double height = headingLineHeight,
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
    double height = headingLineHeight,
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
    double fontSize = 16.0,
    Color color = textColor,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = letterSpacing,
    double height = headingLineHeight,
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

  static TextStyle bodyText({
    String fontFamily = fontFace,
    double fontSize = 16.0,
    Color color = textColor,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = letterSpacing,
    double height = bodyLineHeight,
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

  static TextStyle bodyTextBold({
    String fontFamily = fontFace,
    double fontSize = 16.0,
    Color color = textColor,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = letterSpacing,
    double height = bodyLineHeight,
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

  static TextStyle caption1({
    String fontFamily = fontFace,
    double fontSize = 14.0,
    Color color = neutralColor400,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = letterSpacing,
    double height = headingLineHeight,
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

  static TextStyle caption1Bold({
    String fontFamily = fontFace,
    double fontSize = 14.0,
    Color color = neutralColor400,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = letterSpacing,
    double height = headingLineHeight,
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

  static TextStyle caption2({
    String fontFamily = fontFace,
    double fontSize = 12.0,
    Color color = neutralColor400,
    FontWeight fontWeight = FontWeight.normal,
    double letterSpacing = letterSpacing,
    double height = headingLineHeight,
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

