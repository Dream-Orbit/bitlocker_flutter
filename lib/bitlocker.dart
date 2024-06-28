import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'models/bit_locker_status_model.dart';

export 'models/bit_locker_status_model.dart';

class Bitlocker {
  Future<BitLockerStatusModel?> getDriveStatus({
    required String drive,
  }) async {
    var result = await Process.run("manage-bde", ['-status', drive]);
    if (result.exitCode == -1) {
      log('Error while getting status with exit code ${result.exitCode}');
      return null;
    } else {
      String output = result.stdout.toString();
      BitLockerStatusModel manageBdeStatusResponse =
          BitLockerStatusModel.fromOutputString(output);
      return manageBdeStatusResponse;
    }
  }

  Future<bool> unlockDrive(
      {required String drive, required String password}) async {
    final powershellCommands = [
      'ConvertTo-SecureString -String $password -AsPlainText -Force',
      'Unlock-BitLocker -MountPoint $drive -Password (ConvertTo-SecureString $password -AsPlainText -Force)'
    ];
    var status = await getDriveStatus(drive: drive);
    if (status == null) {
      log('Error while getting status');
      return false;
    }

    if (status.lockStatus == LockStatusEnum.unLocked) {
      log('Device is already unlocked.');
      return true;
    }

    try {
      final combinedCommand = powershellCommands.join('; ');
      final result =
          await Process.run('powershell', ['-Command', combinedCommand]);

      if (result.exitCode == 0 && result.stderr.toString().isEmpty) {
        log('Drive Unlocked successfully');
        log('Unlocked Output: ${result.stdout}');
        return true;
      } else {
        log('Error while unlocking');
        log('Exit Code: ${result.exitCode}');
        log('Unlocked Error Output: ${result.stderr}');
        return false;
      }
    } catch (e) {
      log('Exception: $e');
      return false;
    }
  }

  Future<void> _waitForEncryption({required String drive}) async {
    bool shouldWait = true;
    await Future.doWhile(() async {
      if (!shouldWait) {
        return false;
      } else {
        var status = await getDriveStatus(drive: drive);
        if (status == null) {
          return false;
        } else {
          shouldWait = status.percentageEncrypted < 100;
        }
        await Future.delayed(
          const Duration(seconds: 1),
        );
      }
      return shouldWait;
    });
  }

  Future<void> lockDrive({
    required String drive,
    required String password,
  }) async {
    var status = await getDriveStatus(drive: drive);
    if (status == null) {
      log('Error while getting status');
      return;
    }
    if (status.lockStatus == LockStatusEnum.locked) {
      log('Device is already locked.');
      return;
    }

    if (status.percentageEncrypted != 100) {
      if (status.conversionStatus ==
          ConversionStatusEnum.encryptionInProgress) {
        await _waitForEncryption(drive: drive);
      } else {
        bool turnOnStatus = await turnOnBitlocker(drive: drive);
        if (turnOnStatus) {
          await _waitForEncryption(drive: drive);
        } else {
          return;
        }
      }
    }

    bool addProtectorStatus = await addPasswordProtectorToBitlocker(
      drive: drive,
      password: password,
    );

    if (!addProtectorStatus) {
      log('Error while adding password protector');
      return;
    }

    bool enableProtectorStatus = await _enableProtectors(
      drive: drive,
      shouldEnable: true,
    );

    if (!enableProtectorStatus) {
      log('Error while enable protectors');
      return;
    }

    var result = await Process.run("manage-bde", [
      '-lock',
      drive,
    ]);

    if (result.exitCode == -1) {
      log('Error while lock the drive with exit code ${result.exitCode}.');
      return;
    } else {
      var output = result.stdout.toString();
      log(output);
      log('Drive locked successfully.');
    }
  }

  Future<bool> turnOnBitlocker({
    required String drive,
  }) async {
    var result = await Process.run("manage-bde", ['-on', drive]);
    if (result.exitCode == -1) {
      log('Error while turn on encryption with exit code ${result.exitCode}.');
      return false;
    } else {
      var output = result.stdout.toString();
      log(output.toString());
      log('Turn on Encryption successfully.');
      return true;
    }
  }

  Future<bool> turnOffBitlocker({
    required String drive,
  }) async {
    var result = await Process.run("manage-bde", ['-off', drive]);
    if (result.exitCode == -1) {
      log('Error while turn off encryption with exit code ${result.exitCode}.');
      return false;
    } else {
      var output = result.stdout.toString();
      log(output.toString());
      log('Turn off Encryption successfully.');
      return true;
    }
  }

  Future<bool> addPasswordProtectorToBitlocker({
    required String password,
    required String drive,
  }) async {
    var status = await getDriveStatus(drive: drive);
    if (status == null) {
      log('Error while getting status');
      return false;
    }
    if (status.keyProtector.any((element) => element == "Password")) {
      log('Password Protector is already added');
      return true;
    }

    final powershellCommands = [
      'ConvertTo-SecureString -String $password -AsPlainText -Force',
      'Add-BitLockerKeyProtector -MountPoint $drive -PasswordProtector -Password (ConvertTo-SecureString $password -AsPlainText -Force)'
    ];

    try {
      final combinedCommand = powershellCommands.join('; ');
      final result =
          await Process.run('powershell', ['-Command', combinedCommand]);

      if (result.exitCode == 0) {
        log('Password Protector Added successfully');
        log('Output: ${result.stdout}');
        return true;
      } else {
        log('Error in add Password Protector');
        log('Exit Code: ${result.exitCode}');
        log('Error Output: ${result.stderr}');
        return false;
      }
    } catch (e) {
      log('Exception: $e');
      return false;
    }
  }

  Future<bool> _enableProtectors({
    required String drive,
    required bool shouldEnable,
  }) async {
    var status = await getDriveStatus(drive: drive);
    if (status == null) {
      log('Error while getting status');
      return false;
    }
    if (status.protectionStatus == ProtectionStatusEnum.protectionOn) {
      log('Protection status is already enable');
      return true;
    }

    var result = await Process.run("manage-bde", [
      '-protectors',
      '-${shouldEnable ? 'enable' : 'disable'}',
      drive,
    ]);

    if (result.exitCode == -1) {
      log('Error while enable Protectors with exit code ${result.exitCode}.');
      return false;
    } else {
      var output = result.stdout.toString();
      log(output);
      log('Protection enable successfully.');
      return true;
    }
  }

  Future<void> changePassword(
      {required String drive,
      required String oldPassword,
      required String newPassword}) {
    throw UnimplementedError();
  }

  Future<void> resetPassword({required String drive}) {
    throw UnimplementedError();
  }
}
