part of 'mrz_parser.dart';

class MRZFieldParser {
  MRZFieldParser._();

  static String parseDocumentNumber(final String input) => _trim(input);

  static String parseDocumentType(final String input) => _trim(input);

  static String parseCountryCode(final String input) => _trim(input);

  static String parseNationality(final String input) => _trim(input);

  static String parseOptionalData(final String input) => _trim(input);

  static List<String> parseNames(final String input) {
    final words = input.trimChar('<').split('<<');
    final result = [
      words.isNotEmpty ? _trim(words[0]) : '',
      words.length > 1 ? _trim(words[1]) : '',
    ];
    return result;
  }

  static DateTime parseBirthDate(final String input) {
    final formattedInput = _formatDate(input);
    return _parseDate(formattedInput, DateTime.now().year - 2000);
  }

  static DateTime parseExpiryDate(final String input) {
    final formattedInput = _formatDate(input);
    return _parseDate(formattedInput, 70);
  }

  static Sex parseSex(final String input) {
    switch (input) {
      case 'M':
        return Sex.male;
      case 'F':
        return Sex.female;
      default:
        return Sex.none;
    }
  }

  static String _formatDate(final String input) => _trim(input);

  static DateTime _parseDate(final String input, final int milestoneYear) {
    final parsedYear = int.parse(input.substring(0, 2));
    final centennial = (parsedYear > milestoneYear) ? '19' : '20';
    return DateTime.parse(centennial + input);
  }

  static String _trim(final String input) =>
      input.replaceAngleBracketsWithSpaces().trim();
}
