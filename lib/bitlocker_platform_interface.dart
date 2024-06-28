import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bitlocker_method_channel.dart';

abstract class BitlockerPlatform extends PlatformInterface {
  /// Constructs a BitlockerPlatform.
  BitlockerPlatform() : super(token: _token);

  static final Object _token = Object();

  static BitlockerPlatform _instance = MethodChannelBitlocker();

  /// The default instance of [BitlockerPlatform] to use.
  ///
  /// Defaults to [MethodChannelBitlocker].
  static BitlockerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BitlockerPlatform] when
  /// they register themselves.
  static set instance(BitlockerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
