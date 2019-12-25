part of mrz_parser;

class _TD3MRZFormat {
  _TD3MRZFormat._();

  static const _linesLength = 44;
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
