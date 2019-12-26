part of mrz_parser;

class MRZFieldFormatter {
  MRZFieldFormatter._();

  static final _numeric = RegExp(r'^[0-9]+$');

  static String formatDocumentNumber(String input) {
    input = _formatText(input);
    input = input.trim();
    return input;
  }

  static String formatDocumentType(String input) {
    input = _formatText(input);
    input = _replaceSimilarDigitsWithLetters(input);
    input = input.trim();
    return input;
  }

  static String formatCountryCode(String input) {
    input = _formatText(input);
    input = _replaceSimilarDigitsWithLetters(input);
    input = input.trim();
    return input;
  }

  static List<String> formatNames(String input) {
    input = _replaceSimilarDigitsWithLetters(input);
    input = _trimChar(input, '<');
    final split = input.split('<<');
    final result = [
      split.isNotEmpty ? _formatText(split[0]).trim() : '',
      split.length > 1 ? _formatText(split[1]).trim() : '',
    ];
    return result;
  }

  static String formatCheckDigit(String input) {
    input = _replaceSimilarLettersWithDigits(input);
    input = input.trim();
    return input;
  }

  static String formatNationality(String input) {
    input = _formatText(input);
    input = _replaceSimilarDigitsWithLetters(input);
    input = input.trim();
    return input;
  }

  static String formatDate(String input) {
    input = _formatText(input);
    input = _replaceSimilarLettersWithDigits(input);
    input = input.trim();
    return input;
  }

  static DateTime formatBirthDate(String input) {
    input = formatDate(input);
    if (!_isNumeric(input)) {
      return null;
    }
    return _parseDate(input, DateTime.now().year - 2000);
  }

  static DateTime formatExpiryDate(String input) {
    input = formatDate(input);
    if (!_isNumeric(input)) {
      return null;
    }
    return _parseDate(input, 70);
  }

  static String formatOptionalData(String input) {
    input = _formatText(input);
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

  static String _replaceSimilarDigitsWithLetters(String input) => input
      .replaceAll('0', 'O')
      .replaceAll('1', 'I')
      .replaceAll('2', 'Z')
      .replaceAll('8', 'B');

  static String _replaceSimilarLettersWithDigits(String input) => input
      .replaceAll('O', '0')
      .replaceAll('Q', '0')
      .replaceAll('U', '0')
      .replaceAll('D', '0')
      .replaceAll('I', '1')
      .replaceAll('Z', '2')
      .replaceAll('B', '8');

  static bool _isNumeric(String input) => _numeric.hasMatch(input);

  static String _formatText(String input) => input.replaceAll('<', ' ');

  static DateTime _parseDate(String input, int milestoneYear) {
    final parsedYear = int.tryParse(input.substring(0, 2));
    final centennial = (parsedYear > milestoneYear) ? '19' : '20';

    return DateTime.tryParse(centennial + input);
  }

  static String _trimChar(String input, String char) {
    var start = 0, end = input.length - 1;
    while (start < input.length && input[start] == char) {
      start++;
    }
    while (end >= 0 && input[end] == char) {
      end--;
    }
    return start < end ? input.substring(start, end + 1) : '';
  }
}
