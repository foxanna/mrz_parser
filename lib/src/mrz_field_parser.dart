part of mrz_parser;

class MRZFieldParser {
  MRZFieldParser._();

  static String parseDocumentNumber(String input) => _trim(input);

  static String parseDocumentType(String input) => _trim(input);

  static String parseCountryCode(String input) => _trim(input);

  static String parseNationality(String input) => _trim(input);

  static String parseOptionalData(String input) => _trim(input);

  static List<String> parseNames(String input) {
    input = input.trimChar('<');
    final split = input.split('<<');
    final result = [
      split.isNotEmpty ? _trim(split[0]) : '',
      split.length > 1 ? _trim(split[1]) : '',
    ];
    return result;
  }

  static DateTime parseBirthDate(String input) {
    final formattedInput = _formatDate(input);
    return _parseDate(formattedInput, DateTime.now().year - 2000);
  }

  static DateTime parseExpiryDate(String input) {
    final formattedInput = _formatDate(input);
    return _parseDate(formattedInput, 70);
  }

  static Sex parseSex(String input) {
    switch (input) {
      case 'M':
        return Sex.male;
      case 'F':
        return Sex.female;
      default:
        return Sex.none;
    }
  }

  static String _formatDate(String input) => _trim(input);

  static DateTime _parseDate(String input, int milestoneYear) {
    final parsedYear = int.parse(input.substring(0, 2));
    final centennial = (parsedYear > milestoneYear) ? '19' : '20';
    return DateTime.parse(centennial + input);
  }

  static String _trim(String input) =>
      input.replaceAngleBracketsWithSpaces().trim();
}
