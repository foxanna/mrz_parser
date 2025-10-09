part of 'mrz_parser.dart';

class _DriverLicenseMRZFormatParser {
  _DriverLicenseMRZFormatParser._();

  static const _lineLength = 30;
  static const _linesCount = 1;

  static bool isValidInput(List<String> input) =>
      input.length == _linesCount &&
      input.every((s) => s.length == _lineLength) &&
      input[0].startsWith('D');

  static MRZDriverLicenseResult parse(List<String> input) {
    if (!isValidInput(input)) {
      throw const InvalidMRZInputException();
    }

    final line = input[0];

    final documentTypeRaw = line.substring(0, 1);
    final configurationRaw = line.substring(1, 2);
    final countryCodeRaw = line.substring(2, 5);
    final versionRaw = line.substring(5, 6);
    final documentNumberRaw = line.substring(6, 16);
    final randomDataRaw = line.substring(16, 29);
    final checkDigitRaw = line.substring(29, 30);

    final documentTypeFixed =
        MRZFieldRecognitionDefectsFixer.fixDocumentType(documentTypeRaw);
    final configurationFixed = configurationRaw;
    final countryCodeFixed =
        MRZFieldRecognitionDefectsFixer.fixCountryCode(countryCodeRaw);
    final versionFixed = versionRaw;
    final documentNumberFixed = documentNumberRaw;
    final randomDataFixed = randomDataRaw;
    final checkDigitFixed =
        MRZFieldRecognitionDefectsFixer.fixCheckDigit(checkDigitRaw);

    final documentNumberIsValid = int.tryParse(checkDigitFixed) ==
        MRZCheckDigitCalculator.getCheckDigit(documentNumberFixed);
    if (!documentNumberIsValid) {
      throw const InvalidDocumentNumberException();
    }

    final documentType = MRZFieldParser.parseDocumentType(documentTypeFixed);
    final configuration = MRZFieldParser.parseDocumentType(configurationFixed);
    final countryCode = MRZFieldParser.parseCountryCode(countryCodeFixed);
    final version = versionFixed;
    final documentNumber =
        MRZFieldParser.parseDocumentNumber(documentNumberFixed);
    final randomData = MRZFieldParser.parseOptionalData(randomDataFixed);

    return MRZDriverLicenseResult(
      documentType: documentType,
      configuration: configuration,
      countryCode: countryCode,
      version: version,
      documentNumber: documentNumber,
      randomData: randomData,
    );
  }
}
