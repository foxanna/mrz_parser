class MRZDriverLicenseResult {
  const MRZDriverLicenseResult({
    required this.documentType,
    required this.configuration,
    required this.countryCode,
    required this.version,
    required this.documentNumber,
    required this.randomData,
  });

  final String documentType;
  final String configuration;
  final String countryCode;
  final String version;
  final String documentNumber;
  final String randomData;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MRZDriverLicenseResult &&
          runtimeType == other.runtimeType &&
          documentType == other.documentType &&
          configuration == other.configuration &&
          countryCode == other.countryCode &&
          version == other.version &&
          documentNumber == other.documentNumber &&
          randomData == other.randomData;

  @override
  int get hashCode =>
      documentType.hashCode ^
      configuration.hashCode ^
      countryCode.hashCode ^
      version.hashCode ^
      documentNumber.hashCode ^
      randomData.hashCode;
}
