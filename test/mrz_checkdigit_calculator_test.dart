import 'package:mrz_parser/mrz_parser.dart';
import 'package:test/test.dart';

void main() {
  test('check empty input', () {
    expect(MRZCheckDigitCalculator.getCheckDigit('<<<'), 0);
  });

  test('check document number', () {
    expect(MRZCheckDigitCalculator.getCheckDigit('L898902C3'), 6);
    expect(MRZCheckDigitCalculator.getCheckDigit('C01X00T47'), 8);
    expect(MRZCheckDigitCalculator.getCheckDigit('990000516'), 4);
    expect(MRZCheckDigitCalculator.getCheckDigit('M5127939<'), 2);
    expect(MRZCheckDigitCalculator.getCheckDigit('L4041765<'), 4);
  });

  test('check birth date', () {
    expect(MRZCheckDigitCalculator.getCheckDigit('680229'), 5);
    expect(MRZCheckDigitCalculator.getCheckDigit('640812'), 5);
    expect(MRZCheckDigitCalculator.getCheckDigit('740812'), 2);
  });
}
