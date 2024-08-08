part of 'mrz_parser.dart';

class _TD3MRZFormatParser {
  _TD3MRZFormatParser._();

  static const _linesLength = 44;
  static const _linesCount = 2;

  static bool isValidInput(List<String> input) =>
      input.length == _linesCount &&
      input.every((s) => s.length == _linesLength);

  static MRZResult parse(List<String> input) {
    if (!isValidInput(input)) {
      throw const InvalidMRZInputException();
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
    final optionalDataRaw = secondLine.substring(28, isVisaDocument ? 44 : 42);
    final optionalDataCheckDigitRaw = isVisaDocument ? null : secondLine[42];
    final finalCheckDigitRaw = isVisaDocument ? null : secondLine.substring(43);

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
    final optionalDataCheckDigitFixed = optionalDataCheckDigitRaw != null
        ? MRZFieldRecognitionDefectsFixer.fixCheckDigit(
            optionalDataCheckDigitRaw,
          )
        : null;
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

    if (optionalDataCheckDigitFixed != null) {
      final optionalDataIsValid = (int.tryParse(optionalDataCheckDigitFixed) ==
              MRZCheckDigitCalculator.getCheckDigit(optionalDataFixed)) ||
          ((optionalDataCheckDigitFixed == '<') &&
              MRZFieldParser.parseOptionalData(optionalDataFixed).isEmpty);

      if (!optionalDataIsValid) {
        throw const InvalidOptionalDataException();
      }
    }

    if (finalCheckDigitFixed != null) {
      final finalCheckStringFixed =
          '$documentNumberFixed$documentNumberCheckDigitFixed'
          '$birthDateFixed$birthDateCheckDigitFixed'
          '$expiryDateFixed$expiryDateCheckDigitFixed'
          '$optionalDataFixed${optionalDataCheckDigitFixed ?? ''}';

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
}
