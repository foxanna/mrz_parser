import 'package:mrz_parser/mrz_parser.dart';
import 'package:mrz_parser/mrz_result.dart';
import 'package:test/test.dart';

void main() {
  group('invalid input returns null', () {
    final testExecutor =
        (List<String> input) => expect(MRZParser.parse(input), null);

    test('null input', () => testExecutor(null));

    test('1-line input', () => testExecutor(['0123456789']));

    test(
        '4-lines input',
        () => testExecutor([
              '0123456789',
              '0123456789',
              '0123456789',
              '0123456789',
            ]));
    test(
        '3-lines input with 10 symbols',
        () => testExecutor([
              '0123456789',
              '0123456789',
              '0123456789',
            ]));
    test(
        '3-lines input with 40 symbols',
        () => testExecutor([
              '0123456789012345678901234567890123456789',
              '0123456789012345678901234567890123456789',
              '0123456789012345678901234567890123456789',
            ]));

    test(
        '2-lines input with 10 symbols',
        () => testExecutor([
              '0123456789',
              '0123456789',
            ]));

    test(
        '2-lines input with 40 symbols',
        () => testExecutor([
              '0123456789012345678901234567890123456789',
              '0123456789012345678901234567890123456789',
            ]));

    test(
        '2-lines input with 50 symbols',
        () => testExecutor([
              '01234567890123456789012345678901234567890123456789',
              '01234567890123456789012345678901234567890123456789',
            ]));
  });

  test('correct mrz input parses', () {
    // Arrange
    const mrzLines = <String>[
      'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
      'L898902C36UTO7408122F1204159ZE184226B<<<<<10'
    ];
    const parsed = MRZResult();

    // Act
    final result = MRZParser.parse(mrzLines);

    // Assert
    expect(result, parsed);
  });

  test('any TD1 format input parses', () {
    // Arrange
    const mrzLines = <String>[
      '012345678901234567890123456789',
      '012345678901234567890123456789',
      '012345678901234567890123456789',
    ];
    const parsed = MRZResult();

    // Act
    final result = MRZParser.parse(mrzLines);

    // Assert
    expect(result, parsed);
  });

  test('any TD2 format input parses', () {
    // Arrange
    const mrzLines = <String>[
      '012345678901234567890123456789012345',
      '012345678901234567890123456789012345',
    ];
    const parsed = MRZResult();

    // Act
    final result = MRZParser.parse(mrzLines);

    // Assert
    expect(result, parsed);
  });

  test('any TD3 format input parses', () {
    // Arrange
    const mrzLines = <String>[
      '01234567890123456789012345678901234567890123',
      '01234567890123456789012345678901234567890123',
    ];
    const parsed = MRZResult();

    // Act
    final result = MRZParser.parse(mrzLines);

    // Assert
    expect(result, parsed);
  });
}
