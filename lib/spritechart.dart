import 'dart:async';

import 'package:flutter/services.dart';

class Spritechart {
  static const MethodChannel _channel =
      const MethodChannel('spritechart');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
