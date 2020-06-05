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

    final documentTypeFixed =
        MRZFieldRecognitionDefectsFixer.fixDocumentType(documentTypeRaw);
    final countryCodeFixed =
        MRZFieldRecognitionDefectsFixer.fixCountryCode(countryCodeRaw);
    final documentNumberFixed = documentNumberRaw;
    final documentNumberCheckDigitFixed =
        MRZFieldRecognitionDefectsFixer.fixCheckDigit(
            documentNumberCheckDigitRaw);
    final optionalDataFixed = optionalDataRaw;
    final birthDateFixed =
        MRZFieldRecognitionDefectsFixer.fixDate(birthDateRaw);
    final birthDateCheckDigitFixed =
        MRZFieldRecognitionDefectsFixer.fixCheckDigit(birthDateCheckDigitRaw);
    final sexFixed = MRZFieldRecognitionDefectsFixer.fixSex(sexRaw);
    final expiryDateFixed =
        MRZFieldRecognitionDefectsFixer.fixDate(expiryDateRaw);
    final expiryDateCheckDigitFixed =
        MRZFieldRecognitionDefectsFixer.fixCheckDigit(expiryDateCheckDigitRaw);
    final nationalityFixed =
        MRZFieldRecognitionDefectsFixer.fixNationality(nationalityRaw);
    final optionalData2Fixed = optionalData2Raw;
    final finalCheckDigitFixed =
        MRZFieldRecognitionDefectsFixer.fixCheckDigit(finalCheckDigitRaw);
    final namesFixed = MRZFieldRecognitionDefectsFixer.fixNames(namesRaw);

    final documentNumberIsValid = int.tryParse(documentNumberCheckDigitFixed) ==
        MRZCheckDigitCalculator.getCheckDigit(documentNumberFixed);

    if (!documentNumberIsValid) {
      return null;
    }

    final birthDateIsValid = int.tryParse(birthDateCheckDigitFixed) ==
        MRZCheckDigitCalculator.getCheckDigit(birthDateFixed);

    if (!birthDateIsValid) {
      return null;
    }

    final expiryDateIsValid = int.tryParse(expiryDateCheckDigitFixed) ==
        MRZCheckDigitCalculator.getCheckDigit(expiryDateFixed);

    if (!expiryDateIsValid) {
      return null;
    }

    if (finalCheckDigitFixed != null) {
      final finalCheckStringFixed =
          '$documentNumberFixed$documentNumberCheckDigitFixed'
          '$optionalDataFixed'
          '$birthDateFixed$birthDateCheckDigitFixed'
          '$expiryDateFixed$expiryDateCheckDigitFixed'
          '$optionalData2Fixed';
      final finalCheckStringIsValid = int.tryParse(finalCheckDigitFixed) ==
          MRZCheckDigitCalculator.getCheckDigit(finalCheckStringFixed);

      if (!finalCheckStringIsValid) {
        return null;
      }
    }

    final documentType =
        MRZFieldFormatter.formatDocumentType(documentTypeFixed);
    final countryCode = MRZFieldFormatter.formatCountryCode(countryCodeFixed);
    final documentNumber =
        MRZFieldFormatter.formatDocumentNumber(documentNumberFixed);
    final optionalData =
        MRZFieldFormatter.formatOptionalData(optionalDataFixed);
    final birthDate = MRZFieldFormatter.formatBirthDate(birthDateFixed);
    final sex = MRZFieldFormatter.formatSex(sexFixed);
    final expiryDate = MRZFieldFormatter.formatExpiryDate(expiryDateFixed);
    final nationality = MRZFieldFormatter.formatNationality(nationalityFixed);
    final optionalData2 =
        MRZFieldFormatter.formatOptionalData(optionalData2Fixed);
    final names = MRZFieldFormatter.formatNames(namesFixed);

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
