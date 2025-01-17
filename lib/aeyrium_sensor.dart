import 'dart:async';

import 'package:flutter/services.dart';

const EventChannel _sensorEventChannel =
    EventChannel('plugins.aeyrium.com/sensor');

class SensorEvent {
  /// Pitch from the device in radians
  /// A pitch is a rotation around a lateral (X) axis that passes through the device from side to side
  final double pitch;

  ///Roll value from the device in radians
  ///A roll is a rotation around a longitudinal (Y) axis that passes through the device from its top to bottom
  final double roll;

  ///Azimuth value from the device in radians
  final double azimuth;
//  final double inclination;

  final int accuracy;

  SensorEvent(this.pitch, this.roll, this.azimuth, this.accuracy);

  @override
  String toString() => '[Event: (pitch: $pitch, roll: $roll, azimuth: $azimuth)]';
}

class AeyriumSensor {
  static Stream<SensorEvent> _sensorEvents;

  AeyriumSensor._();

  /// A broadcast stream of events from the device rotation sensor.
  static Stream<SensorEvent> get sensorEvents {
    if (_sensorEvents == null) {
      _sensorEvents = _sensorEventChannel
          .receiveBroadcastStream()
          .map((dynamic event) => _listToSensorEvent(event.cast<double>()));
    }
    return _sensorEvents;
  }

  static SensorEvent _listToSensorEvent(List<double> list) {
    return SensorEvent(list[0], list[1], list[2], list[3].toInt());
  }
}
