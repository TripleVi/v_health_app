import 'dart:math' as math;

import 'package:dio/dio.dart';

class WeatherService {
  Future<double> fetchCurrentTemperature(double lat, double lon) async {
    final dio = Dio();
    final response = await dio.get(
      "https://api.openweathermap.org/data/2.5/weather",
      queryParameters: {
        "lat": lat,
        "lon": lon,
        "appid": "c5be7ecd1d05100b67e1958fa95c1781",
      }  
    );
    // Unit of the returned temperature is Kelvin
    return response.statusCode! == 200
        ? response.data!["main"]["temp"]
        : throw "No temperature found";
  }

  double calculateAltitude(double pressure, double temp) {
    const p0 = 1013.25; // average sea level pressure (hPa)
    const k = 8.314; // Boltzmann's constant (J(K^-1)(mol^-1))
    const m = 0.02897; // mass of one air molecule (kg/mol)
    const g = 9.80665; // (m/s^2)
    temp += 273.15; // Convert C degree to Kelvin
    return -math.log(pressure/p0) * k * temp / g / m;
  }

}