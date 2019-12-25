part of mrz_parser;

class _TD1MRZFormat {
  _TD1MRZFormat._();

  static const _lineLength = 30;

  static bool isValidInput(List<String> input) =>
      input != null && input.every((s) => s.length == _lineLength);

  static MRZResult parse(List<String> input) {
    if (!isValidInput(input)) {
      return null;
    }

    return const MRZResult();
  }
}
