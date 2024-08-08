// ignore_for_file: constant_identifier_names

part of 'mrz_parser.dart';

class MRZCheckDigitCalculator {
  MRZCheckDigitCalculator._();

  static final _weights = [7, 3, 1];

  static int getCheckDigit(String input) {
    final checkSum = input.codeUnits
        .map((c) {
          if (_isCapitalLetter(c)) {
            return c - _A + 10;
          }
          if (_isDigit(c)) {
            return c - _0;
          }
          return 0;
        })
        .toList()
        .asMap()
        .map((i, v) => MapEntry(i, v * _weights[i % _weights.length]))
        .values
        .reduce((value, element) => value + element);

    return checkSum % 10;
  }

  static bool _isCapitalLetter(int c) => c >= _A && c <= _Z;

  static bool _isDigit(int c) => c >= _0 && c <= _9;

  static const int _A = 65;
  static const int _Z = 90;
  static const int _0 = 48;
  static const int _9 = 57;
}
