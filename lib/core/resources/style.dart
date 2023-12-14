// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class AppStyle {
  AppStyle._();

  static const horizontalPadding = 8.0;
  static const borderRadius = 12.0;

  // Base

  static TextStyle heading_1({
    String fontFamily = Constants.fontFace,
    double fontSize = Constants.heading_1_size,
    Color color = Constants.textColor,
    FontWeight fontWeight = FontWeight.w700,
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
    String fontFamily = Constants.fontFace,
    double fontSize = Constants.paragraph_size,
    Color color = Constants.paragraphColor,
    FontWeight fontWeight = FontWeight.w300,
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

  static TextStyle label({
    String fontFamily = Constants.fontFace,
    double fontSize = 14.0,
    Color color = const Color(0xFF707070),
    FontWeight fontWeight = FontWeight.w300,
    double letterSpacing = Constants.letter_spacing,
    double height = 1.0,
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
    String fontFamily = Constants.fontFace,
    double fontSize = 14.0,
    Color color = Constants.paragraphColor,
    FontWeight fontWeight = FontWeight.w300,
    double letterSpacing = Constants.letter_spacing,
    double height = 1.0,
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

  // Activity Tracking Screen

  static TextStyle tracking_heading_1() {
    return heading_1(
      fontSize: 40.0,
      fontWeight: FontWeight.w500,
      height: 1.0,
    );
  }

  static TextStyle tracking_heading_2() {
    return heading_2(
      fontSize: 24.0,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle tracking_heading_3() {
    return heading_2(
      fontSize: 20.0,
      fontWeight: FontWeight.w300,
    );
  }
}

