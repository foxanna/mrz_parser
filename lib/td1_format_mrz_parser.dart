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

    return const MRZResult();
  }
}
