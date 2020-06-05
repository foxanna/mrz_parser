import 'package:collection/collection.dart';
import 'package:mrz_parser/mrz_parser.dart';
import 'package:test/test.dart';

void main() {
  test('formats document number', () {
    expect(MRZFieldParser.parseDocumentNumber('FHDJEURI3'), 'FHDJEURI3');
    expect(MRZFieldParser.parseDocumentNumber('FHDJEURI3<'), 'FHDJEURI3');
    expect(MRZFieldParser.parseDocumentNumber('<<<<<'), '');
  });

  test('formats document type', () {
    expect(MRZFieldParser.parseDocumentType('V'), 'V');
    expect(MRZFieldParser.parseDocumentType('P<<'), 'P');
    expect(MRZFieldParser.parseDocumentType('0128'), 'OIZB');
    expect(MRZFieldParser.parseDocumentType('<<<<'), '');
  });

  test('formats country code', () {
    expect(MRZFieldParser.parseCountryCode('UA'), 'UA');
    expect(MRZFieldParser.parseCountryCode('D<<'), 'D');
    expect(MRZFieldParser.parseCountryCode('0128'), 'OIZB');
    expect(MRZFieldParser.parseCountryCode('<<<<'), '');
  });

  test('formats names', () {
    const equality = DeepCollectionEquality();
    expect(
        equality.equals(
            MRZFieldParser.parseNames('<<SURNAME<<GIVEN<NAMES<<<<<<'),
            ['SURNAME', 'GIVEN NAMES']),
        true);
    expect(
        equality.equals(MRZFieldParser.parseNames('<<SURNAME<<NAME<<<<<<'),
            ['SURNAME', 'NAME']),
        true);
    expect(
        equality.equals(
            MRZFieldParser.parseNames('<<SURNAME<<<<<<<<<'), ['SURNAME', '']),
        true);
    expect(equality.equals(MRZFieldParser.parseNames('<<<<<<<<<<<'), ['', '']),
        true);
  });
//
//  test('formats check digit', () {
//    expect(MRZFieldFormatter.formatCheckDigit('8'), '8');
//    expect(MRZFieldFormatter.formatCheckDigit('<6<'), '<6<');
//    expect(MRZFieldFormatter.formatCheckDigit('0QUDIZB'), '0000128');
//    expect(MRZFieldFormatter.formatCheckDigit('<<<<'), '<<<<');
//  });

  test('formats nationality', () {
    expect(MRZFieldParser.parseNationality('UA'), 'UA');
    expect(MRZFieldParser.parseNationality('D<<'), 'D');
    expect(MRZFieldParser.parseNationality('0128'), 'OIZB');
    expect(MRZFieldParser.parseNationality('<<<<'), '');
  });
//
//  test('formats date', () {
//    expect(MRZFieldFormatter.formatDate('190213'), '190213');
//    expect(MRZFieldFormatter.formatDate('<190213<<'), '190213');
//    expect(MRZFieldFormatter.formatDate('0QUDIZB'), '0000128');
//    expect(MRZFieldFormatter.formatDate('<<<<'), '');
//  });

  test('formats birth date', () {
    expect(MRZFieldParser.parseBirthDate('170213'), DateTime(2017, 02, 13));
    expect(MRZFieldParser.parseBirthDate('190213'), DateTime(2019, 02, 13));
    expect(MRZFieldParser.parseBirthDate('200213'), DateTime(1920, 02, 13));
    expect(MRZFieldParser.parseBirthDate('210213'), DateTime(1921, 02, 13));
    expect(MRZFieldParser.parseBirthDate('770213'), DateTime(1977, 02, 13));
  });

  test('formats expiry date', () {
    expect(MRZFieldParser.parseExpiryDate('170213'), DateTime(2017, 02, 13));
    expect(MRZFieldParser.parseExpiryDate('710213'), DateTime(1971, 02, 13));
    expect(MRZFieldParser.parseExpiryDate('700213'), DateTime(2070, 02, 13));
    expect(MRZFieldParser.parseExpiryDate('690213'), DateTime(2069, 02, 13));
  });

  test('formats optional data', () {
    expect(MRZFieldParser.parseOptionalData('FHDJEURI3'), 'FHDJEURI3');
    expect(MRZFieldParser.parseOptionalData('FHDJEURI3<'), 'FHDJEURI3');
    expect(MRZFieldParser.parseOptionalData('<<<<<'), '');
  });

  test('formats sex', () {
    expect(MRZFieldParser.parseSex('M'), Sex.male);
    expect(MRZFieldParser.parseSex('F'), Sex.female);
    expect(MRZFieldParser.parseSex('P'), Sex.female);
    expect(MRZFieldParser.parseSex('<'), Sex.none);
    expect(MRZFieldParser.parseSex('<<<<<'), Sex.none);
  });
}
