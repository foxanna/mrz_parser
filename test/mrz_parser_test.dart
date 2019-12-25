import 'package:mrz_parser/mrz_parser.dart';
import 'package:mrz_parser/mrz_result.dart';
import 'package:test/test.dart';

void main() {
  test('null input returns null', () {
    // Arrange

    // Act
    final result = MRZParser.parse(null);

    // Assert
    expect(result, null);
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
