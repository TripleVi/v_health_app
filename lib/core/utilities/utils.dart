import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;

import 'constants.dart';

class MyUtils {
  MyUtils._();

  static int getHours(int minute) {
    return minute ~/ 60;
  }

//   static getMedianValue(List<ChartData> chartData) {
//     if (chartData.isEmpty) {
//       return 0;
//     }

//     int median = 0;
//     for (ChartData i in chartData) {
//       median += i.y;
//     }
//     return median / chartData.length;
//   }

  static double getMaxValue(List<dynamic> input) {
    int max = 0;
    for (dynamic i in input) {
      if (i.y > max) {
        max = i.y;
      }
    }
    return max.toDouble() + 100;
  }

  static double getMinValue(List<dynamic> input) {
    int min = 100000000;
    for (dynamic i in input) {
      if (i.y < min) {
        min = i.y;
      }
    }
    return min.toDouble() - (min * 10 / 100);
  }

  static int getMinutes(int minute) {
    return minute % 60;
  }

  static String getDateAsSqlFormat(DateTime date) {
    var outputFormat = DateFormat(Constants.db_date_format);
    var outputDate = outputFormat.format(date);
    return outputDate.toString();
  }

  static String getCurrentDate() {
    return DateFormat(Constants.display_date_format)
        .format(DateTime.now())
        .toString();
  }

  static String getFormattedDate(DateTime time) {
    var outputFormat = DateFormat(Constants.db_date_format);
    var outputDate = outputFormat.format(time);

    return outputDate.toString();
  }

//   static String getFormattedDate(String date) {
//     var convertedDate = DateFormat(Constants.db_date_format).parse(date);
//     var outputFormat = DateFormat(Constants.display_date_format);
//     var outputDate = outputFormat.format(convertedDate);

//     return outputDate.toString();
//   }

  static bool onlyCharsAndSpace(String input) {
    final pattern = RegExp(r"^[a-zA-Z0-9]+(?: [a-zA-Z0-9]+)*$");
    return pattern.hasMatch(input);
  }

  static void closeKeyboard(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

//   static String? onlyCharacters(String? value) {
//     if (value == null || value.isEmpty) {
//       return null;
//     }
//     return null;
//   }

//   static Future<String?> validUsername(String? value) async {
//     if (value == null || value.isEmpty) {
//       return "Please fill this field";
//     } else if (!onlyCharsAndSpace(value)) {
//       return "Only alphabet characters and space are allowed!";
//     }
//     bool isExist = await existUser(value);
//     if (!isExist) {
//       return "Username already existed!";
//     }
//     return null;
//   }

//   static Future<bool> existUser(String keyword) async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection(UserFields.container)
//         .where(UserFields.username, isEqualTo: keyword)
//         .get(const GetOptions(source: Source.server));

//     return snapshot.docs.isNotEmpty;
//   }

  static String? requiredDateField(String? value) {
    if (value == null || value.isEmpty) {
      return "Please fill this field";
    }
    return null;
  }

  static String? requiredField(String? value) {
    if (value == null || value.isEmpty) {
      return "Please fill this field";
    }
    return null;
  }

  static String? requiredTextField(String? value) {
    if (value == null || value.isEmpty) {
      return "Please fill this field";
    } else if (!onlyCharsAndSpace(value)) {
      return "Only alphabet characters and space are allowed!";
    }
    return null;
  }

  static String? requiredIntField(String? value) {
    if (value == null || value == "0" || value == "") {
      return "Please fill this field";
    }
    return null;
  }

  static String? requiredDoubleField(String? value) {
    if (value == null || value == "0.0" || value == "") {
      return "Please fill this field";
    }
    return null;
  }

  // static InputDecoration getDecoration(String label) {
  //   return InputDecoration(
  //     // prefixIconConstraints: const BoxConstraints(
  //     //     maxHeight: 1, maxWidth: 1, minHeight: 0, minWidth: 0),
  //     border: const OutlineInputBorder(
  //       borderRadius: BorderRadius.all(Radius.circular(10)),
  //     ),
  //     labelText: label,
  //     contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
  //   );
  // }

  static String getDateFirstLetter(String date) {
    DateTime d = DateFormat(Constants.db_date_format).parse(date);
    return DateFormat('EEEE').format(d).substring(0, 3);
  }

  static String get_date_subtracted_by_i(String startDate, int i) {
    DateTime start = DateFormat(Constants.db_date_format).parse(startDate);
    return DateFormat(Constants.db_date_format)
        .format(start.subtract(Duration(days: i)));
  }

  static Map<String, String> getFormattedDistance(double? distance) {
    const unit = "km";
    if(distance == null) {
      return {
        "value": "--",
        "unit": unit,
      };
    }
    // m -> km
    distance /= 1000;
    final regex = RegExp(r'^\d+\.0*[1-9]?');
    final match = regex.firstMatch("$distance");
    return {
      "value": match![0]!,
      "unit": unit,
    };
  }

  static Map<String, String> getFormattedSpeed(double? speed, [bool inSeconds = true]) {
    final unit = inSeconds ? "m/s" : "km/h";
    if(speed == null) {
      return {
        "value": "--",
        "unit": unit
      };
    }
    // speed (m/s)
    return {
      "value": (inSeconds ? speed : speed*3.6).toStringAsFixed(2),
      "unit": unit,
    };
  }

  static Map<String, String> getFormattedPace(double? speed, [bool inMeters = true]) {
    final unit = inMeters ? "/m" : "/km";
    if(speed == null) {
      return {
        "value": "--",
        "unit": unit
      };
    }
    if(speed == 0.0) {
      return {
        "value": "0'0''",
        "unit": unit,
      };
    }
    final pace = (1 / speed * (inMeters ? 1 : 1000)).ceil();
    final mins = pace ~/ 60;
    final seconds = pace - mins * 60;
    return {
      "value": "$mins'$seconds''",
      "unit": unit,
    };
  }

  static String getFormattedDuration(int secondsElapsed) {
    // Duration format: 00:00:00
    final timeElapsed = Duration(seconds: secondsElapsed);
    return timeElapsed.toString().substring(0, 7);
  }

  static Future<io.Directory> getAppTempDirectory() {
    return pp.getTemporaryDirectory();
  }

  static Future<io.File> getAppTempFile(String name) async {
    final dir = await getAppTempDirectory();
    final path = p.join(dir.path, name);
    return io.File(path);
  }

  static String getFileName(io.File file) {
    return p.basename(file.path);
  }

  static String getPartOfDay(DateTime dateTime) {
    final hours = dateTime.hour;
    String value;
    if(hours >= 0 && hours <= 12){ 
      value = "Morning"; 
    } else if(hours >= 12 && hours <= 16){
      value = "Afternoon"; 
    } else if(hours >= 16 && hours <= 21){ 
      value = "Evening";
    } else { 
      value = "Night";
    }
    return value;
  }
}
