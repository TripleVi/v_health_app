// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../core/utilities/constants.dart';

class TextTypes {
  TextTypes._();

  static Text heading_1({
    required String content,
    String fontFamily = Constants.fontFace,
    double fontSize = Constants.heading_1_size,
    Color color = Constants.textColor,
    FontWeight fontWeight = FontWeight.w700,
    double letterSpacing = Constants.letter_spacing,
    double height = Constants.line_height,
    TextAlign textAlign = TextAlign.left,
  }) {
    return Text(
      content,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
        color: color,
      ),
    );
  }

  static Text heading_2({
    required String content,
    String fontFamily = Constants.fontFace,
    double fontSize = Constants.heading_2_size,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = Constants.letter_spacing,
    double height = Constants.line_height,
    Color color = Constants.primaryColor,
    TextAlign textAlign = TextAlign.left,
  }) {
    return Text(
      content,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
        color: color,
      ),
    );
  }

  static Text paragraph({
    required String content,
    String fontFamily = Constants.fontFace,
    double fontSize = Constants.paragraph_size,
    Color color = Constants.paragraphColor,
    FontWeight fontWeight = FontWeight.w300,
    double letterSpacing = Constants.letter_spacing,
    double height = Constants.line_height,
    TextAlign textAlign = TextAlign.left,
  }) {
    return Text(
      content,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
        color: color,
      ),
    );
  }
}
