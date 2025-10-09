import 'package:mrz_parser/mrz_parser.dart';
import 'package:test/test.dart';

void main() {
  void expectResult({
    List<String?>? input,
    MRZDriverLicenseResult? expectedOutput,
  }) =>
      expect(DriverLicenseParser.parse(input), expectedOutput);

  void expectException<T>({List<String?>? input}) =>
      expect(() => DriverLicenseParser.parse(input), throwsA(isA<T>()));

  group('invalid input throws $InvalidMRZInputException', () {
    test(
      'null input',
      () => expectException<InvalidMRZInputException>(),
    );

    test(
      '2-line input',
      () => expectException<InvalidMRZInputException>(
        input: ['D1NLD11234567890ABCDEFGHIJKLM7', 'extra line'],
      ),
    );

    test(
      'wrong length',
      () => expectException<InvalidMRZInputException>(
        input: ['D1NLD11234567890'],
      ),
    );

    test(
      'not starting with D',
      () => expectException<InvalidMRZInputException>(
        input: ['P1NLD11234567890ABCDEFGHIJKLM7'],
      ),
    );
  });

  group('invalid document number throws $InvalidDocumentNumberException', () {
    test(
      'wrong check digit',
      () => expectException<InvalidDocumentNumberException>(
        input: ['D1NLD11234567890ABCDEFGHIJKLM0'],
      ),
    );
  });

  group('valid input returns $MRZDriverLicenseResult', () {
    test(
      'basic valid driver license',
      () => expectResult(
        input: ['D1NLD11234567890ABCDEFGHIJKLM7'],
        expectedOutput: const MRZDriverLicenseResult(
          documentType: 'D',
          configuration: '1',
          countryCode: 'NLD',
          version: '1',
          documentNumber: '1234567890',
          randomData: 'ABCDEFGHIJKLM',
        ),
      ),
    );

    test(
      'driver license with angle brackets',
      () => expectResult(
        input: ['D<NLD11234567890ABCDEFGHIJ<<<7'],
        expectedOutput: const MRZDriverLicenseResult(
          documentType: 'D',
          configuration: '',
          countryCode: 'NLD',
          version: '1',
          documentNumber: '1234567890',
          randomData: 'ABCDEFGHIJ',
        ),
      ),
    );
  });

  group('tryParse returns null for invalid input', () {
    test(
      'null input',
      () => expect(DriverLicenseParser.tryParse(null), isNull),
    );

    test(
      'invalid format',
      () => expect(DriverLicenseParser.tryParse(['invalid']), isNull),
    );
  });
}
