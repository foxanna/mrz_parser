import 'package:mrz_parser/mrz_parser.dart';
import 'package:mrz_parser/mrz_result.dart';
import 'package:test/test.dart';

void main() {
  final testExecutor = ({List<String> input, MRZResult expectedOutput}) =>
      expect(MRZParser.parse(input), expectedOutput);
  final nullTestExecutor = ({List<String> input}) =>
      testExecutor(input: input, expectedOutput: null);

  group('invalid input returns null', () {
    test('null input', () => nullTestExecutor(input: null));

    test('1-line input', () => nullTestExecutor(input: ['0123456789']));

    test(
        '4-lines input',
        () => nullTestExecutor(input: [
              '0123456789',
              '0123456789',
              '0123456789',
              '0123456789',
            ]));
    test(
        '3-lines input with 10 symbols',
        () => nullTestExecutor(input: [
              '0123456789',
              '0123456789',
              '0123456789',
            ]));
    test(
        '3-lines input with 40 symbols',
        () => nullTestExecutor(input: [
              '0123456789012345678901234567890123456789',
              '0123456789012345678901234567890123456789',
              '0123456789012345678901234567890123456789',
            ]));

    test(
        '2-lines input with 10 symbols',
        () => nullTestExecutor(input: [
              '0123456789',
              '0123456789',
            ]));

    test(
        '2-lines input with 40 symbols',
        () => nullTestExecutor(input: [
              '0123456789012345678901234567890123456789',
              '0123456789012345678901234567890123456789',
            ]));

    test(
        '2-lines input with 50 symbols',
        () => nullTestExecutor(input: [
              '01234567890123456789012345678901234567890123456789',
              '01234567890123456789012345678901234567890123456789',
            ]));
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

  group('TD2 format', () {
    test('TD2 correct input parses', () {
      testExecutor(
          input: [
            'P<D<<MUSTERMANN<<ERIKA<<<<<<<<<<<<<<',
            'C01X00T478D<<6408125F2702283<<<<<<<4'
          ],
          expectedOutput: MRZResult(
            documentType: 'P',
            countryCode: 'D',
            surnames: 'MUSTERMANN',
            givenNames: 'ERIKA',
            documentNumber: 'C01X00T47',
            nationalityCountryCode: 'D',
            birthDate: DateTime(1964, 08, 12),
            sex: Sex.female,
            expiryDate: DateTime(2027, 02, 28),
            personalNumber: '',
            personalNumber2: null,
          ));
    });
  });

  group('TD3 passport', () {
    test('correct input parses', () {
      testExecutor(
          input: [
            'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
            'L898902C36UTO7408122F1204159ZE184226B<<<<<10'
          ],
          expectedOutput: MRZResult(
            documentType: 'P',
            countryCode: 'UTO',
            surnames: 'ERIKSSON',
            givenNames: 'ANNA MARIA',
            documentNumber: 'L898902C3',
            nationalityCountryCode: 'UTO',
            birthDate: DateTime(1974, 08, 12),
            sex: Sex.female,
            expiryDate: DateTime(2012, 04, 15),
            personalNumber: 'ZE184226B',
            personalNumber2: null,
          ));
    });

    test('document number check digit does not match returns null', () {
      nullTestExecutor(input: [
        'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
        'L898902C37UTO7408122F1204159ZE184226B<<<<<10'
      ]);
    });

    test('birth date check digit does not match returns null', () {
      nullTestExecutor(input: [
        'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
        'L898902C36UTO7408120F1204159ZE184226B<<<<<10'
      ]);
    });

    test('expiry date check digit does not match returns null', () {
      nullTestExecutor(input: [
        'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
        'L898902C36UTO7408122F1204150ZE184226B<<<<<10'
      ]);
    });

    test('personal number check digit does not match returns null', () {
      nullTestExecutor(input: [
        'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
        'L898902C36UTO7408122F1204159ZE184226B<<<<<00'
      ]);
    });

    test('final check digit does not match returns null', () {
      nullTestExecutor(input: [
        'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
        'L898902C36UTO7408122F1204159ZE184226B<<<<<19'
      ]);
    });
  });

  group('MRV-A visa', () {
    test('correct input parses', () {
      testExecutor(
          input: [
            'VNUSATRAVELER<<HAPPY<<<<<<<<<<<<<<<<<<<<<<<<',
            '12345678<8KOR5001013F1304071B3SE000IL4243934'
          ],
          expectedOutput: MRZResult(
            documentType: 'VN',
            countryCode: 'USA',
            surnames: 'TRAVELER',
            givenNames: 'HAPPY',
            documentNumber: '12345678',
            nationalityCountryCode: 'KOR',
            birthDate: DateTime(1950, 01, 01),
            sex: Sex.female,
            expiryDate: DateTime(2013, 04, 07),
            personalNumber: 'B3SE000IL4243934',
            personalNumber2: null,
          ));
    });

    test('document number check digit does not match returns null', () {
      nullTestExecutor(input: [
        'VNUSATRAVELER<<HAPPY<<<<<<<<<<<<<<<<<<<<<<<<',
        '12345678<0KOR5001013F1304071B3SE000IL4243934'
      ]);
    });

    test('birth date check digit does not match returns null', () {
      nullTestExecutor(input: [
        'VNUSATRAVELER<<HAPPY<<<<<<<<<<<<<<<<<<<<<<<<',
        '12345678<8KOR5001010F1304071B3SE000IL4243934'
      ]);
    });

    test('expiry date check digit does not match returns null', () {
      nullTestExecutor(input: [
        'VNUSATRAVELER<<HAPPY<<<<<<<<<<<<<<<<<<<<<<<<',
        '12345678<8KOR5001013F1304070B3SE000IL4243934'
      ]);
    });
  });
}
