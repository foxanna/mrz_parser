part of mrz_parser;

class _TD2MRZFormatParser {
  _TD2MRZFormatParser._();

  static const _linesLength = 36;
  static const _linesCount = 2;

  static bool isValidInput(List<String> input) =>
      input.length == _linesCount &&
      input.every((s) => s.length == _linesLength);

  static MRZResult parse(List<String> input) {
    if (!isValidInput(input)) {
      return null;
    }

    final firstLine = input[0];
    final secondLine = input[1];

    final isVisaDocument = firstLine[0] == 'V';
    final documentTypeRaw = firstLine.substring(0, 2);
    final countryCodeRaw = firstLine.substring(2, 5);
    final namesRaw = firstLine.substring(5);
    final documentNumberRaw = secondLine.substring(0, 9);
    final documentNumberCheckDigitRaw = secondLine[9];
    final nationalityRaw = secondLine.substring(10, 13);
    final birthDateRaw = secondLine.substring(13, 19);
    final birthDateCheckDigitRaw = secondLine[19];
    final sexRaw = secondLine.substring(20, 21);
    final expiryDateRaw = secondLine.substring(21, 27);
    final expiryDateCheckDigitRaw = secondLine[27];
    final optionalDataRaw = secondLine.substring(28, isVisaDocument ? 36 : 35);
    final finalCheckDigitRaw = isVisaDocument ? null : secondLine.substring(35);

    final documentNumber =
        MRZFieldFormatter.formatDocumentNumber(documentNumberRaw);
    final documentNumberCheckDigit =
        MRZFieldFormatter.formatCheckDigit(documentNumberCheckDigitRaw);
    final documentNumberIsValid = int.tryParse(documentNumberCheckDigit) ==
        MRZCheckDigitCalculator.getCheckDigit(documentNumber);

    if (!documentNumberIsValid) {
      return null;
    }

    final birthDateString = MRZFieldFormatter.formatDate(birthDateRaw);
    final birthDateCheckDigit =
        MRZFieldFormatter.formatCheckDigit(birthDateCheckDigitRaw);
    final birthDateIsValid = int.tryParse(birthDateCheckDigit) ==
        MRZCheckDigitCalculator.getCheckDigit(birthDateString);

    if (!birthDateIsValid) {
      return null;
    }

    final expiryDateString = MRZFieldFormatter.formatDate(expiryDateRaw);
    final expiryDateCheckDigit =
        MRZFieldFormatter.formatCheckDigit(expiryDateCheckDigitRaw);
    final expiryDateIsValid = int.tryParse(expiryDateCheckDigit) ==
        MRZCheckDigitCalculator.getCheckDigit(expiryDateString);

    if (!expiryDateIsValid) {
      return null;
    }

    if (finalCheckDigitRaw != null) {
      final finalCheckDigit =
          MRZFieldFormatter.formatCheckDigit(finalCheckDigitRaw);
      final finalCheckString = documentNumber +
          documentNumberCheckDigit +
          birthDateString +
          birthDateCheckDigit +
          expiryDateString +
          expiryDateCheckDigit +
          optionalDataRaw;
      final finalCheckStringIsValid = int.tryParse(finalCheckDigit) ==
          MRZCheckDigitCalculator.getCheckDigit(finalCheckString);

      if (!finalCheckStringIsValid) {
        return null;
      }
    }

    final documentType = MRZFieldFormatter.formatDocumentType(documentTypeRaw);
    final countryCode = MRZFieldFormatter.formatCountryCode(countryCodeRaw);
    final names = MRZFieldFormatter.formatNames(namesRaw);
    final nationality = MRZFieldFormatter.formatNationality(nationalityRaw);
    final birthDate = MRZFieldFormatter.formatBirthDate(birthDateString);
    final sex = MRZFieldFormatter.formatSex(sexRaw);
    final expiryDate = MRZFieldFormatter.formatExpiryDate(expiryDateString);
    final optionalData = MRZFieldFormatter.formatOptionalData(optionalDataRaw);

    return MRZResult(
      documentType: documentType,
      countryCode: countryCode,
      surnames: names[0],
      givenNames: names[1],
      documentNumber: documentNumber,
      nationalityCountryCode: nationality,
      birthDate: birthDate,
      sex: sex,
      expiryDate: expiryDate,
      personalNumber: optionalData,
      personalNumber2: null,
    );
  }
}
