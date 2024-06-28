import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bitlocker_platform_interface.dart';

/// An implementation of [BitlockerPlatform] that uses method channels.
class MethodChannelBitlocker extends BitlockerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bitlocker');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
