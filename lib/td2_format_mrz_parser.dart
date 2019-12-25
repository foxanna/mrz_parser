part of mrz_parser;

class _TD2MRZFormat {
  _TD2MRZFormat._();

  static const _linesLength = 36;
  static const _linesCount = 2;

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
