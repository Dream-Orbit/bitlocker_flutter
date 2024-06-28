# BitLocker Flutter Plugin

![Pub Version](https://img.shields.io/pub/v/bitlocker)

## Description

A Flutter plugin to manage BitLocker drive encryption on Windows platforms. This plugin provides functionalities to check drive status, lock, unlock, enable, and disable BitLocker encryption using Dart.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [API Reference](#api-reference)
- [License](#license)
- [Credits](#credits)

## Installation

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  bitlocker: ^latest_version
```

Then run `flutter pub get` to install the package.

## Usage

Here's a simple example to check the status of a drive:

```dart
import 'package:bitlocker/bitlocker.dart';

void main() async {
  Bitlocker bitlocker = Bitlocker();

  var status = await bitlocker.getDriveStatus(drive: 'C:');
  print(status);
}
```

## Features

- Check drive status
- Lock and unlock drives
- Enable and disable BitLocker encryption
- Add password protector to BitLocker


## API Reference

Create an instance of the Bitlocker class:

```dart
final bitlocker = Bitlocker();
```

### getDriveStatus

Get the BitLocker status of a drive.

```dart
Future<BitLockerStatusModel?> getDriveStatus({required String drive})
```

### unlockDrive

Unlock a BitLocker-encrypted drive.

```dart
Future<bool> unlockDrive({required String drive, required String password})
```

### lockDrive

Lock a BitLocker-encrypted drive.

```dart
Future<void> lockDrive({required String drive, required String password})
```

### turnOnBitlocker

Turn on BitLocker encryption for a drive.

```dart
Future<bool> turnOnBitlocker({required String drive})
```

### turnOffBitlocker

Turn off BitLocker encryption for a drive.

```dart
Future<bool> turnOffBitlocker({required String drive})
```

### addPasswordProtectorToBitlocker

Add a password protector to a BitLocker-encrypted drive.

```dart
Future<bool> addPasswordProtectorToBitlocker({required String password, required String drive})
```

### changePassword

Change the password of a BitLocker-encrypted drive.

```dart
Future<void> changePassword({required String drive, required String oldPassword, required String newPassword})
```

### resetPassword

Reset the password of a BitLocker-encrypted drive.

```dart
Future<void> resetPassword({required String drive})
```

Note: `changePassword` and `resetPassword` methods are currently unimplemented and will throw an `UnimplementedError` if called.


## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Credits

Developed by [DreamOrbit](https://dreamorbit.com/).
