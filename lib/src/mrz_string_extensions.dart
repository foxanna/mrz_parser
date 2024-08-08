part of 'mrz_parser.dart';

extension _MRZStringExtensions on String {
  static final _validInput = RegExp(r'^[A-Z|0-9|<]+$');

  bool get isValidMRZInput => _validInput.hasMatch(this);

  String trimChar(String char) {
    if (isEmpty || char.isEmpty) {
      return this;
    }

    var start = 0;
    var end = length - 1;
    while (start < length && this[start] == char) {
      start++;
    }
    while (end >= 0 && this[end] == char) {
      end--;
    }
    return start < end ? substring(start, end + 1) : '';
  }

  String replaceSimilarDigitsWithLetters() => replaceAll('0', 'O')
      .replaceAll('1', 'I')
      .replaceAll('2', 'Z')
      .replaceAll('8', 'B');

  String replaceSimilarLettersWithDigits() => replaceAll('O', '0')
      .replaceAll('Q', '0')
      .replaceAll('U', '0')
      .replaceAll('D', '0')
      .replaceAll('I', '1')
      .replaceAll('Z', '2')
      .replaceAll('B', '8');

  String replaceAngleBracketsWithSpaces() => replaceAll('<', ' ');
}
