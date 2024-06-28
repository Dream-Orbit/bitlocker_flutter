import 'package:bitlocker/services/bit_locker_regex.dart';

enum LockStatusEnum {
  locked,
  unLocked,
}

enum ConversionStatusEnum {
  fullyDecrypted,
  encryptionInProgress,
  fullyEncrypted,
  unknown,
}

enum ProtectionStatusEnum {
  unknown,
  protectionOn,
  protectionOff,
}

class BitLockerStatusModel {
  final double size;
  final double bitLockerVersion;
  final ConversionStatusEnum conversionStatus;
  final double percentageEncrypted;
  final String encryptionMethod;
  final ProtectionStatusEnum protectionStatus;
  final LockStatusEnum lockStatus;
  final String identificationField;
  final List<String> keyProtector;

  BitLockerStatusModel({
    required this.size,
    required this.bitLockerVersion,
    required this.conversionStatus,
    required this.percentageEncrypted,
    required this.encryptionMethod,
    required this.protectionStatus,
    required this.lockStatus,
    required this.identificationField,
    required this.keyProtector,
  });

  factory BitLockerStatusModel.fromOutputString(String output) {
    String extractedConversionStatus =
        extractValue(RegularExpressions.conversionStatusPattern, output).trim();
    String extractedLockStatus =
        extractValue(RegularExpressions.lockStatusPattern, output).trim();
    String extractedProtectionStatus =
        extractValue(RegularExpressions.protectionStatusPattern, output).trim();
    String extractedSize = extractValue(RegularExpressions.sizePattern, output)
        .trim()
        .replaceAll(' GB', '');
    String extractedPercentageEncrypted =
        extractValue(RegularExpressions.percentageEncryptedPattern, output)
            .trim()
            .replaceAll('%', '');
    LockStatusEnum lockStatus;
    ConversionStatusEnum status;
    ProtectionStatusEnum protectionStatus;

    switch (extractedLockStatus) {
      case "Locked":
        lockStatus = LockStatusEnum.locked;
        break;
      case "Unlocked":
        lockStatus = LockStatusEnum.unLocked;
        break;
      default:
        lockStatus = LockStatusEnum.unLocked;
        break;
    }

    switch (extractedProtectionStatus) {
      case "Protection Off":
        protectionStatus = ProtectionStatusEnum.protectionOff;
        break;
      case "Unknown":
        protectionStatus = ProtectionStatusEnum.unknown;
        break;
      case "Protection On":
        protectionStatus = ProtectionStatusEnum.protectionOn;
        break;
      default:
        protectionStatus = ProtectionStatusEnum.unknown;
        break;
    }

    switch (extractedConversionStatus) {
      case "Fully Encrypted":
        status = ConversionStatusEnum.fullyEncrypted;
        break;
      case "Fully Decrypted":
        status = ConversionStatusEnum.fullyDecrypted;
        break;
      case "Encryption in Progress":
        status = ConversionStatusEnum.encryptionInProgress;
        break;
      case "Unknown":
        status = ConversionStatusEnum.unknown;
        break;
      default:
        status = ConversionStatusEnum.unknown;
        break;
    }

    return BitLockerStatusModel(
      size: double.parse(extractedSize == 'Unknown' ? '0' : extractedSize),
      bitLockerVersion: double.parse(
          extractValue(RegularExpressions.bitLockerVersionPattern, output)
              .trim()),
      conversionStatus: status,
      encryptionMethod:
          extractValue(RegularExpressions.encryptionMethodPattern, output)
              .trim(),
      identificationField:
          extractValue(RegularExpressions.identificationFieldPattern, output),
      lockStatus: lockStatus,
      protectionStatus: protectionStatus,
      percentageEncrypted: double.parse(
          extractedPercentageEncrypted == 'Unknown'
              ? '0'
              : extractedPercentageEncrypted),
      keyProtector: keyProtectorsExtractValue(output),
    );
  }

  //For extract bitlocker status values
  static String extractValue(RegExp pattern, String response) {
    Match? match = pattern.firstMatch(response);
    return match?.group(1) ?? 'Value not found';
  }

  //For extract keyProtector value
  static List<String> keyProtectorsExtractValue(String output) {
    List<String> keyProtectors = [];
    bool isParsing = false;

    for (var line in output.split('\n')) {
      // Remove leading and trailing whitespace
      line = line.trim();

      if (line == 'Key Protectors:') {
        isParsing = true;
      } else if (isParsing && line.isNotEmpty) {
        keyProtectors.add(line);
      } else if (isParsing && line.isEmpty) {
        // Stop parsing once an empty line is encountered
        break;
      }
    }

    return keyProtectors;
  }
}
