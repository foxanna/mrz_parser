import 'package:collection/collection.dart';
import 'package:mrz_parser/mrz_parser.dart';
import 'package:test/test.dart';

void main() {
  test('parses document number', () {
    expect(MRZFieldParser.parseDocumentNumber('FHDJEURI3'), 'FHDJEURI3');
    expect(MRZFieldParser.parseDocumentNumber('R3427<<'), 'R3427');
    expect(MRZFieldParser.parseDocumentNumber('<<<<<'), '');
  });

  test('parses document type', () {
    expect(MRZFieldParser.parseDocumentType('V'), 'V');
    expect(MRZFieldParser.parseDocumentType('P<<'), 'P');
    expect(MRZFieldParser.parseDocumentType('<<<<'), '');
  });

  test('parses country code', () {
    expect(MRZFieldParser.parseCountryCode('UA'), 'UA');
    expect(MRZFieldParser.parseCountryCode('D<<'), 'D');
    expect(MRZFieldParser.parseCountryCode('<<<<'), '');
  });

  test('parses names', () {
    final equality = const DeepCollectionEquality().equals;
    expect(
      equality(
        MRZFieldParser.parseNames('<<SURNAME<<GIVEN<NAMES<<<<<<'),
        ['SURNAME', 'GIVEN NAMES'],
      ),
      isTrue,
    );
    expect(
      equality(
        MRZFieldParser.parseNames('<<SURNAME<<NAME<<<<<<'),
        ['SURNAME', 'NAME'],
      ),
      isTrue,
    );
    expect(
      equality(
        MRZFieldParser.parseNames('<<SURNAME<<<<<<<<<'),
        ['SURNAME', ''],
      ),
      isTrue,
    );
    expect(
      equality(MRZFieldParser.parseNames('<<<<<<<<<<<'), ['', '']),
      isTrue,
    );
  });

  test('parses nationality', () {
    expect(MRZFieldParser.parseNationality('UA'), 'UA');
    expect(MRZFieldParser.parseNationality('D<<'), 'D');
    expect(MRZFieldParser.parseNationality('<<<<'), '');
  });

  test('parses birth date', () {
    expect(MRZFieldParser.parseBirthDate('170213'), DateTime(2017, 02, 13));
    expect(MRZFieldParser.parseBirthDate('190213'), DateTime(2019, 02, 13));
    expect(MRZFieldParser.parseBirthDate('200213'), DateTime(2020, 02, 13));
    expect(MRZFieldParser.parseBirthDate('770213'), DateTime(1977, 02, 13));
  });

  test('parses expiry date', () {
    expect(MRZFieldParser.parseExpiryDate('170213'), DateTime(2017, 02, 13));
    expect(MRZFieldParser.parseExpiryDate('710213'), DateTime(1971, 02, 13));
    expect(MRZFieldParser.parseExpiryDate('700213'), DateTime(2070, 02, 13));
    expect(MRZFieldParser.parseExpiryDate('690213'), DateTime(2069, 02, 13));
  });

  test('parses optional data', () {
    expect(MRZFieldParser.parseOptionalData('FHDJEURI3'), 'FHDJEURI3');
    expect(MRZFieldParser.parseOptionalData('<GDJSKJ34<'), 'GDJSKJ34');
    expect(MRZFieldParser.parseOptionalData('<<<<<'), '');
  });

  test('parses sex', () {
    expect(MRZFieldParser.parseSex('M'), Sex.male);
    expect(MRZFieldParser.parseSex('F'), Sex.female);
    expect(MRZFieldParser.parseSex('<'), Sex.none);
    expect(MRZFieldParser.parseSex('<<<<<'), Sex.none);
  });
}
