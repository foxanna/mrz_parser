import 'package:mrz_parser/mrz_parser.dart';
import 'package:mrz_parser/mrz_result.dart';
import 'package:test/test.dart';

void main() {
  group('invalid input returns null', () {
    final testExecutor =
        (List<String> input) => expect(MRZParser.parse(input), null);

    test('null input', () => testExecutor(null));

    test('one-line input', () => testExecutor(['invalid input']));

    test(
        'four-lines input',
        () => testExecutor([
              'invalid input',
              'invalid input',
              'invalid input',
              'invalid input',
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
}
