part of mrz_parser;

class MRZFieldFormatter {
  MRZFieldFormatter._();

  static String formatDocumentNumber(String input) => _trim(input);

  static String formatDocumentType(String input) => _trim(input);

  static String formatCountryCode(String input) => _trim(input);

  static List<String> formatNames(String input) {
    input = input.trimChar('<');
    final split = input.split('<<');
    final result = [
      split.isNotEmpty ? split[0].replaceAngleBracketsWithSpaces().trim() : '',
      split.length > 1 ? split[1].replaceAngleBracketsWithSpaces().trim() : '',
    ];
    return result;
  }

  static String formatNationality(String input) => _trim(input);

  static DateTime formatBirthDate(String input) {
    input = _formatDate(input);
    return input.isNumeric
        ? _parseDate(input, DateTime.now().year - 2000)
        : null;
  }

  static DateTime formatExpiryDate(String input) {
    input = _formatDate(input);
    return input.isNumeric ? _parseDate(input, 70) : null;
  }

  static String formatOptionalData(String input) => _trim(input);

  static Sex formatSex(String input) {
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
    final parsedYear = int.tryParse(input.substring(0, 2));
    final centennial = (parsedYear > milestoneYear) ? '19' : '20';

    return DateTime.tryParse(centennial + input);
  }

  static String _trim(String input) =>
      input?.replaceAngleBracketsWithSpaces()?.trim();
}
