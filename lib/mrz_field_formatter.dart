part of mrz_parser;

class MRZFieldFormatter {
  MRZFieldFormatter._();

  static String formatDocumentNumber(String input) {
    input = input.replaceAngleBracketsWithSpaces();
    input = input.trim();
    return input;
  }

  static String formatDocumentType(String input) {
    input = input.replaceAngleBracketsWithSpaces();
    input = input.replaceSimilarDigitsWithLetters();
    input = input.trim();
    return input;
  }

  static String formatCountryCode(String input) {
    input = input.replaceAngleBracketsWithSpaces();
    input = input.replaceSimilarDigitsWithLetters();
    input = input.trim();
    return input;
  }

  static List<String> formatNames(String input) {
    input = input.replaceSimilarDigitsWithLetters();
    input = input.trimChar('<');
    final split = input.split('<<');
    final result = [
      split.isNotEmpty ? split[0].replaceAngleBracketsWithSpaces().trim() : '',
      split.length > 1 ? split[1].replaceAngleBracketsWithSpaces().trim() : '',
    ];
    return result;
  }

  static String formatCheckDigit(String input) {
    input = input.replaceSimilarLettersWithDigits();
    input = input.trim();
    return input;
  }

  static String formatNationality(String input) {
    input = input.replaceAngleBracketsWithSpaces();
    input = input.replaceSimilarDigitsWithLetters();
    input = input.trim();
    return input;
  }

  static String formatDate(String input) {
    input = input.replaceAngleBracketsWithSpaces();
    input = input.replaceSimilarLettersWithDigits();
    input = input.trim();
    return input;
  }

  static DateTime formatBirthDate(String input) {
    input = formatDate(input);
    if (!input.isNumeric) {
      return null;
    }
    return _parseDate(input, DateTime.now().year - 2000);
  }

  static DateTime formatExpiryDate(String input) {
    input = formatDate(input);
    if (!input.isNumeric) {
      return null;
    }
    return _parseDate(input, 70);
  }

  static String formatOptionalData(String input) {
    input = input.replaceAngleBracketsWithSpaces();
    input = input.trim();
    return input;
  }

  static Sex formatSex(String input) {
    input = input.replaceAll('P', 'F');

    switch (input) {
      case 'M':
        return Sex.male;
      case 'F':
        return Sex.female;
      default:
        return Sex.none;
    }
  }

  static DateTime _parseDate(String input, int milestoneYear) {
    final parsedYear = int.tryParse(input.substring(0, 2));
    final centennial = (parsedYear > milestoneYear) ? '19' : '20';

    return DateTime.tryParse(centennial + input);
  }
}
