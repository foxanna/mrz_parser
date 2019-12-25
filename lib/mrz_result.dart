class MRZResult {
  const MRZResult({
    this.documentType,
    this.countryCode,
    this.surnames,
    this.givenNames,
    this.documentNumber,
    this.nationalityCountryCode,
    this.birthdate,
    this.sex,
    this.expiryDate,
    this.personalNumber,
    this.personalNumber2,
    this.isDocumentNumberValid,
    this.isBirthdateValid,
    this.isExpiryDateValid,
    this.isPersonalNumberValid,
    this.allCheckDigitsValid,
  });

  final String documentType;
  final String countryCode;
  final String surnames;
  final String givenNames;
  final String documentNumber;
  final String nationalityCountryCode;
  final DateTime birthdate; // `null` if formatting failed
  final String sex; // `null` if formatting failed
  final DateTime expiryDate; // `null` if formatting failed
  final String personalNumber;
  final String personalNumber2; // `null` if not provided

  final bool isDocumentNumberValid;
  final bool isBirthdateValid;
  final bool isExpiryDateValid;
  final bool isPersonalNumberValid;
  final bool allCheckDigitsValid;
}
