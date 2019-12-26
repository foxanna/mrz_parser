part of mrz_parser;

class _TD1MRZFormatParser {
  _TD1MRZFormatParser._();

  static const _linesLength = 30;
  static const _linesCount = 3;

  static bool isValidInput(List<String> input) =>
      input.length == _linesCount &&
      input.every((s) => s.length == _linesLength);

  static MRZResult parse(List<String> input) {
    if (!isValidInput(input)) {
      return null;
    }

    final firstLine = input[0];
    final secondLine = input[1];
    final thirdLine = input[2];

    final documentTypeRaw = firstLine.substring(0, 2);
    final countryCodeRaw = firstLine.substring(2, 5);
    final documentNumberRaw = firstLine.substring(5, 14);
    final documentNumberCheckDigitRaw = firstLine[14];
    final optionalDataRaw = firstLine.substring(15, 30);
    final birthDateRaw = secondLine.substring(0, 6);
    final birthDateCheckDigitRaw = secondLine[6];
    final sexRaw = secondLine.substring(7, 8);
    final expiryDateRaw = secondLine.substring(8, 14);
    final expiryDateCheckDigitRaw = secondLine[14];
    final nationalityRaw = secondLine.substring(15, 18);
    final optionalData2Raw = secondLine.substring(18, 29);
    final finalCheckDigitRaw = secondLine[29];
    final namesRaw = thirdLine.substring(0, 30);

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
          optionalDataRaw +
          birthDateString +
          birthDateCheckDigit +
          expiryDateString +
          expiryDateCheckDigit +
          optionalData2Raw;
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
    final optionalData2 =
        MRZFieldFormatter.formatOptionalData(optionalData2Raw);

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
      personalNumber2: optionalData2,
    );
  }
}
