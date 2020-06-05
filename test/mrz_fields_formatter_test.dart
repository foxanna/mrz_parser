import 'package:collection/collection.dart';
import 'package:mrz_parser/mrz_parser.dart';
import 'package:test/test.dart';

void main() {
  test('formats document number', () {
    expect(MRZFieldFormatter.formatDocumentNumber('FHDJEURI3'), 'FHDJEURI3');
    expect(MRZFieldFormatter.formatDocumentNumber('FHDJEURI3<'), 'FHDJEURI3');
    expect(MRZFieldFormatter.formatDocumentNumber('<<<<<'), '');
  });

  test('formats document type', () {
    expect(MRZFieldFormatter.formatDocumentType('V'), 'V');
    expect(MRZFieldFormatter.formatDocumentType('P<<'), 'P');
    expect(MRZFieldFormatter.formatDocumentType('0128'), 'OIZB');
    expect(MRZFieldFormatter.formatDocumentType('<<<<'), '');
  });

  test('formats country code', () {
    expect(MRZFieldFormatter.formatCountryCode('UA'), 'UA');
    expect(MRZFieldFormatter.formatCountryCode('D<<'), 'D');
    expect(MRZFieldFormatter.formatCountryCode('0128'), 'OIZB');
    expect(MRZFieldFormatter.formatCountryCode('<<<<'), '');
  });

  test('formats names', () {
    const equality = DeepCollectionEquality();
    expect(
        equality.equals(
            MRZFieldFormatter.formatNames('<<SURNAME<<GIVEN<NAMES<<<<<<'),
            ['SURNAME', 'GIVEN NAMES']),
        true);
    expect(
        equality.equals(MRZFieldFormatter.formatNames('<<SURNAME<<NAME<<<<<<'),
            ['SURNAME', 'NAME']),
        true);
    expect(
        equality.equals(MRZFieldFormatter.formatNames('<<SURNAME<<<<<<<<<'),
            ['SURNAME', '']),
        true);
    expect(
        equality.equals(MRZFieldFormatter.formatNames('<<<<<<<<<<<'), ['', '']),
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
    expect(MRZFieldFormatter.formatNationality('UA'), 'UA');
    expect(MRZFieldFormatter.formatNationality('D<<'), 'D');
    expect(MRZFieldFormatter.formatNationality('0128'), 'OIZB');
    expect(MRZFieldFormatter.formatNationality('<<<<'), '');
  });
//
//  test('formats date', () {
//    expect(MRZFieldFormatter.formatDate('190213'), '190213');
//    expect(MRZFieldFormatter.formatDate('<190213<<'), '190213');
//    expect(MRZFieldFormatter.formatDate('0QUDIZB'), '0000128');
//    expect(MRZFieldFormatter.formatDate('<<<<'), '');
//  });

  test('formats birth date', () {
    expect(MRZFieldFormatter.formatBirthDate('170213'), DateTime(2017, 02, 13));
    expect(MRZFieldFormatter.formatBirthDate('190213'), DateTime(2019, 02, 13));
    expect(MRZFieldFormatter.formatBirthDate('200213'), DateTime(1920, 02, 13));
    expect(MRZFieldFormatter.formatBirthDate('210213'), DateTime(1921, 02, 13));
    expect(MRZFieldFormatter.formatBirthDate('770213'), DateTime(1977, 02, 13));
  });

  test('formats expiry date', () {
    expect(
        MRZFieldFormatter.formatExpiryDate('170213'), DateTime(2017, 02, 13));
    expect(
        MRZFieldFormatter.formatExpiryDate('710213'), DateTime(1971, 02, 13));
    expect(
        MRZFieldFormatter.formatExpiryDate('700213'), DateTime(2070, 02, 13));
    expect(
        MRZFieldFormatter.formatExpiryDate('690213'), DateTime(2069, 02, 13));
  });

  test('formats optional data', () {
    expect(MRZFieldFormatter.formatOptionalData('FHDJEURI3'), 'FHDJEURI3');
    expect(MRZFieldFormatter.formatOptionalData('FHDJEURI3<'), 'FHDJEURI3');
    expect(MRZFieldFormatter.formatOptionalData('<<<<<'), '');
  });

  test('formats sex', () {
    expect(MRZFieldFormatter.formatSex('M'), Sex.male);
    expect(MRZFieldFormatter.formatSex('F'), Sex.female);
    expect(MRZFieldFormatter.formatSex('P'), Sex.female);
    expect(MRZFieldFormatter.formatSex('<'), Sex.none);
    expect(MRZFieldFormatter.formatSex('<<<<<'), Sex.none);
  });
}
