// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

class Constants {
  Constants._();

  static const db_date_format = "yyyy/MM/dd";
  static const display_date_format = "MMM dd, yyyy";

  static const primaryColor = Color(0xFFEB6440);
  static const textColor = Color(0xff434242);
  static const paragraphColor = Color(0xff7D7D7D);

  static const fontFace = 'NeueHass';
  static const paragraph_size = 16.0;
  static const heading_1_size = 24.0;
  static const heading_2_size = 20.0;
  static const letter_spacing = 0.5;
  static const line_height = 1.4;

  static const backIcon = Icons.arrow_back_ios_outlined;

  static const SensorDataUpdateKey = 'sensor-update';
  static const SensorDataServiceInitKey = 'sensor-init';
  static const HourlyDataUpdateKey = 'hourly-update';
  static const QuarterlyUpdateKey = 'quarterly-update';

  static const HourlyDataUpdateIdentifier = 'hourly-update-identifier';
  static const QuarterlyUpdateIdentifier = 'quarterly-update-identifier';

  static const cloud_service_post_url = "https://localhost:5000/report/upload";
  static const classificationFileName = "classified.txt";
}
