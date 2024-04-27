import "package:flutter_sensors/flutter_sensors.dart";

class SensorService {
  SensorService();

  Future<Stream<List<double>>> accelerometerEvents() async {
    // SENSOR_DELAY_GAME: real sampling rate = 30 Hz
    // SENSOR_DELAY_FASTEST: real sampling rate = 100 Hz
    return (await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER, 
      interval: Sensors.SENSOR_DELAY_GAME,
    ))
    .map((e) => [e.data[0]/9.8, e.data[1]/9.8, e.data[2]/9.8]);
  }

  // Future<Stream<double>> pressureEvents() async {
  //   final environmentSensors = EnvironmentSensors();
  //   var pressureAvailable = 
  //       await environmentSensors.getSensorAvailable(SensorType.Pressure);
  //   if(pressureAvailable) {
  //     //Pressure in Millibars
  //     return environmentSensors.pressure;
  //   }
  //   throw "No pressure sensor found";
  // }
}