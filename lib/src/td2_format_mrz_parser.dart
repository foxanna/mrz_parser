part of 'mrz_parser.dart';

class _TD2MRZFormatParser {
  _TD2MRZFormatParser._();

  static const _linesLength = 36;
  static const _linesCount = 2;

  static bool isValidInput(List<String> input) =>
      input.length == _linesCount &&
      input.every((s) => s.length == _linesLength);

  static MRZResult parse(List<String> input) {
    if (!isValidInput(input)) {
      throw const InvalidMRZInputException();
    }

    if (_isFrenchId(input)) {
      return _parseFrenchId(input);
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

    final documentTypeFixed =
        MRZFieldRecognitionDefectsFixer.fixDocumentType(documentTypeRaw);
    final countryCodeFixed =
        MRZFieldRecognitionDefectsFixer.fixCountryCode(countryCodeRaw);
    final namesFixed = MRZFieldRecognitionDefectsFixer.fixNames(namesRaw);
    final documentNumberFixed = documentNumberRaw;
    final documentNumberCheckDigitFixed =
        MRZFieldRecognitionDefectsFixer.fixCheckDigit(
      documentNumberCheckDigitRaw,
    );
    final nationalityFixed =
        MRZFieldRecognitionDefectsFixer.fixNationality(nationalityRaw);
    final birthDateFixed =
        MRZFieldRecognitionDefectsFixer.fixDate(birthDateRaw);
    final birthDateCheckDigitFixed =
        MRZFieldRecognitionDefectsFixer.fixCheckDigit(birthDateCheckDigitRaw);
    final sexFixed = MRZFieldRecognitionDefectsFixer.fixSex(sexRaw);
    final expiryDateFixed =
        MRZFieldRecognitionDefectsFixer.fixDate(expiryDateRaw);
    final expiryDateCheckDigitFixed =
        MRZFieldRecognitionDefectsFixer.fixCheckDigit(expiryDateCheckDigitRaw);
    final optionalDataFixed = optionalDataRaw;
    final finalCheckDigitFixed = finalCheckDigitRaw != null
        ? MRZFieldRecognitionDefectsFixer.fixCheckDigit(finalCheckDigitRaw)
        : null;

    final documentNumberIsValid = int.tryParse(documentNumberCheckDigitFixed) ==
        MRZCheckDigitCalculator.getCheckDigit(documentNumberFixed);

    if (!documentNumberIsValid) {
      throw const InvalidDocumentNumberException();
    }

    final birthDateIsValid = int.tryParse(birthDateCheckDigitFixed) ==
        MRZCheckDigitCalculator.getCheckDigit(birthDateFixed);

    if (!birthDateIsValid) {
      throw const InvalidBirthDateException();
    }

    final expiryDateIsValid = int.tryParse(expiryDateCheckDigitFixed) ==
        MRZCheckDigitCalculator.getCheckDigit(expiryDateFixed);

    if (!expiryDateIsValid) {
      throw const InvalidExpiryDateException();
    }

    if (finalCheckDigitFixed != null) {
      final finalCheckStringFixed =
          '$documentNumberFixed$documentNumberCheckDigitFixed'
          '$birthDateFixed$birthDateCheckDigitFixed'
          '$expiryDateFixed$expiryDateCheckDigitFixed'
          '$optionalDataFixed';

      final finalCheckStringIsValid = int.tryParse(finalCheckDigitFixed) ==
          MRZCheckDigitCalculator.getCheckDigit(finalCheckStringFixed);

      if (!finalCheckStringIsValid) {
        throw const InvalidMRZValueException();
      }
    }

    final documentType = MRZFieldParser.parseDocumentType(documentTypeFixed);
    final countryCode = MRZFieldParser.parseCountryCode(countryCodeFixed);
    final names = MRZFieldParser.parseNames(namesFixed);
    final documentNumber =
        MRZFieldParser.parseDocumentNumber(documentNumberFixed);
    final nationality = MRZFieldParser.parseNationality(nationalityFixed);
    final birthDate = MRZFieldParser.parseBirthDate(birthDateFixed);
    final sex = MRZFieldParser.parseSex(sexFixed);
    final expiryDate = MRZFieldParser.parseExpiryDate(expiryDateFixed);
    final optionalData = MRZFieldParser.parseOptionalData(optionalDataFixed);

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
    );
  }

  static bool _isFrenchId(List<String> input) =>
      input[0][0] == 'I' && input[0].substring(2, 5) == 'FRA';

  static MRZResult _parseFrenchId(List<String> input) {
    final firstLine = input[0];
    final secondLine = input[1];

    final documentTypeRaw = firstLine.substring(0, 2);
    final countryCodeRaw = firstLine.substring(2, 5);
    final lastNamesRaw = firstLine.substring(5, 30);
    final departmentAndOfficeRaw = firstLine.substring(30, 36);

    final issueDateRaw = secondLine.substring(0, 4);
    final departmentRaw = secondLine.substring(4, 7);
    final documentNumberRaw = secondLine.substring(0, 12);
    final documentNumberCheckDigitRaw = secondLine[12];
    final givenNamesRaw = secondLine.substring(13, 27);
    final birthDateRaw = secondLine.substring(27, 33);
    final birthDateCheckDigitRaw = secondLine[33];
    final sexRaw = secondLine.substring(34, 35);
    final finalCheckDigitRaw = secondLine.substring(35);

    final documentTypeFixed =
        MRZFieldRecognitionDefectsFixer.fixDocumentType(documentTypeRaw);
    final countryCodeFixed =
        MRZFieldRecognitionDefectsFixer.fixCountryCode(countryCodeRaw);
    final lastNamesFixed =
        MRZFieldRecognitionDefectsFixer.fixNames(lastNamesRaw);
    final departmentAndOfficeFixed = departmentAndOfficeRaw;
    final issueDateFixed =
        MRZFieldRecognitionDefectsFixer.fixDate(issueDateRaw);
    final departmentFixed = departmentRaw;
    final documentNumberFixed = documentNumberRaw;
    final documentNumberCheckDigitFixed =
        MRZFieldRecognitionDefectsFixer.fixCheckDigit(
      documentNumberCheckDigitRaw,
    );
    final givenNamesFixed =
        MRZFieldRecognitionDefectsFixer.fixNames(givenNamesRaw);
    final birthDateFixed =
        MRZFieldRecognitionDefectsFixer.fixDate(birthDateRaw);
    final birthDateCheckDigitFixed =
        MRZFieldRecognitionDefectsFixer.fixCheckDigit(birthDateCheckDigitRaw);
    final sexFixed = MRZFieldRecognitionDefectsFixer.fixSex(sexRaw);
    final finalCheckDigitFixed =
        MRZFieldRecognitionDefectsFixer.fixCheckDigit(finalCheckDigitRaw);

    final documentNumberIsValid = int.tryParse(documentNumberCheckDigitFixed) ==
        MRZCheckDigitCalculator.getCheckDigit(documentNumberFixed);

    if (!documentNumberIsValid) {
      throw const InvalidDocumentNumberException();
    }

    final birthDateIsValid = int.tryParse(birthDateCheckDigitFixed) ==
        MRZCheckDigitCalculator.getCheckDigit(birthDateFixed);

    if (!birthDateIsValid) {
      throw const InvalidBirthDateException();
    }

    final finalCheckStringFixed =
        '$documentTypeFixed$countryCodeFixed$lastNamesFixed'
        '$departmentAndOfficeFixed'
        '$documentNumberFixed$documentNumberCheckDigitFixed'
        '$givenNamesFixed$birthDateFixed$birthDateCheckDigitFixed$sexFixed';

    final finalCheckStringIsValid = int.tryParse(finalCheckDigitFixed) ==
        MRZCheckDigitCalculator.getCheckDigit(finalCheckStringFixed);

    if (!finalCheckStringIsValid) {
      throw const InvalidMRZValueException();
    }

    final documentType = MRZFieldParser.parseDocumentType(documentTypeFixed);
    final countryCode = MRZFieldParser.parseCountryCode(countryCodeFixed);
    final givenNames = MRZFieldParser.parseNames(givenNamesFixed)
        .where((element) => element.isNotEmpty)
        .toList()
        .join(' ');
    final lastNames = MRZFieldParser.parseNames(lastNamesFixed)
        .where((element) => element.isNotEmpty)
        .toList()
        .join(' ');
    final documentNumber =
        MRZFieldParser.parseDocumentNumber(documentNumberFixed);
    final nationality = MRZFieldParser.parseNationality(countryCodeFixed);
    final birthDate = MRZFieldParser.parseBirthDate(birthDateFixed);
    final sex = MRZFieldParser.parseSex(sexFixed);
    final issueDate = MRZFieldParser.parseExpiryDate('${issueDateFixed}01');
    final yearsValid = issueDate.isBefore(DateTime(2014))
        ? 10
        : birthDate.isBefore(
            DateTime(issueDate.year - 18, issueDate.month, issueDate.day),
          )
            ? 15
            : 10;
    final expiryDate =
        DateTime(issueDate.year + yearsValid, issueDate.month, issueDate.day);
    final optionalData =
        MRZFieldParser.parseOptionalData(departmentAndOfficeFixed);
    final optionalData2 = MRZFieldParser.parseOptionalData(departmentFixed);

    return MRZResult(
      documentType: documentType,
      countryCode: countryCode,
      surnames: lastNames,
      givenNames: givenNames,
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
