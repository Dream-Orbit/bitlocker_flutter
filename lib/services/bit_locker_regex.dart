class RegularExpressions {
  static RegExp sizePattern = RegExp(r'Size: (.+)');
  static RegExp bitLockerVersionPattern = RegExp(r'BitLocker Version: (.+)');
  static RegExp conversionStatusPattern = RegExp(r'Conversion Status: (.+)');
  static RegExp percentageEncryptedPattern =
      RegExp(r'Percentage Encrypted: (.+)');
  static RegExp encryptionMethodPattern = RegExp(r'Encryption Method: (.+)');
  static RegExp protectionStatusPattern = RegExp(r'Protection Status: (.+)');
  static RegExp lockStatusPattern = RegExp(r'Lock Status: (.+)');
  static RegExp identificationFieldPattern =
      RegExp(r'Identification Field: (.+)');
  static RegExp keyProtectorsPattern = RegExp(r'Key Protectors:\n([\w\s\n]+)');
}
