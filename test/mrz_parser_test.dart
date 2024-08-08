import 'package:mrz_parser/mrz_parser.dart';
import 'package:test/test.dart';

void main() {
  void expectResult({
    List<String?>? input,
    MRZResult? expectedOutput,
  }) =>
      expect(MRZParser.parse(input), expectedOutput);

  void expectException<T>({List<String?>? input}) =>
      expect(() => MRZParser.parse(input), throwsA(isA<T>()));

  group('invalid input throws $InvalidMRZInputException', () {
    test(
      'null input',
      () => expectException<InvalidMRZInputException>(),
    );

    test(
      '1-line null input',
      () => expectException<InvalidMRZInputException>(input: [null]),
    );

    test(
      '1-line input',
      () => expectException<InvalidMRZInputException>(input: ['0123456789']),
    );

    test(
      '4-lines input',
      () => expectException<InvalidMRZInputException>(
        input: [
          '0123456789',
          '0123456789',
          '0123456789',
          '0123456789',
        ],
      ),
    );
    test(
      '3-lines input with 10 symbols',
      () => expectException<InvalidMRZInputException>(
        input: [
          '0123456789',
          '0123456789',
          '0123456789',
        ],
      ),
    );

    test(
      '3-lines input with 40 symbols',
      () => expectException<InvalidMRZInputException>(
        input: [
          '0123456789012345678901234567890123456789',
          '0123456789012345678901234567890123456789',
          '0123456789012345678901234567890123456789',
        ],
      ),
    );

    test(
      '2-lines input with 10 symbols',
      () => expectException<InvalidMRZInputException>(
        input: [
          '0123456789',
          '0123456789',
        ],
      ),
    );

    test(
      '2-lines input with 40 symbols',
      () => expectException<InvalidMRZInputException>(
        input: [
          '0123456789012345678901234567890123456789',
          '0123456789012345678901234567890123456789',
        ],
      ),
    );

    test(
      '2-lines input with 50 symbols',
      () => expectException<InvalidMRZInputException>(
        input: [
          '01234567890123456789012345678901234567890123456789',
          '01234567890123456789012345678901234567890123456789',
        ],
      ),
    );

    test(
      '2-lines input with 36 invalid symbols',
      () => expectException<InvalidMRZInputException>(
        input: [
          '012345678901234567890123456789!asdfg',
          '012345678901234567890123456789{}>,.?',
        ],
      ),
    );

    test(
      '2-lines input with 44 invalid symbols',
      () => expectException<InvalidMRZInputException>(
        input: [
          '01234567890123456789012345678901234567!asdfg',
          '01234567890123456789012345678901234567{}>,.?',
        ],
      ),
    );

    test(
      '3-lines input with 30 invalid symbols',
      () => expectException<InvalidMRZInputException>(
        input: [
          '012345678901234567890123!asdfg',
          '012345678901234567890123{}>,.?',
        ],
      ),
    );
  });

  group('TD1 passport', () {
    test(
      'correct input parses',
      () => expectResult(
        input: [
          'I<SWE59000002<8198703142391<<<',
          '8703145M1701027SWE<<<<<<<<<<<8',
          'SPECIMEN<<SVEN<<<<<<<<<<<<<<<<',
        ],
        expectedOutput: MRZResult(
          documentType: 'I',
          countryCode: 'SWE',
          surnames: 'SPECIMEN',
          givenNames: 'SVEN',
          documentNumber: '59000002',
          nationalityCountryCode: 'SWE',
          birthDate: DateTime(1987, 03, 14),
          sex: Sex.male,
          expiryDate: DateTime(2017, 01, 02),
          personalNumber: '198703142391',
          personalNumber2: '',
        ),
      ),
    );
    test(
      'correct input with long document number (Belgian ID card from PRADO)',
      () => expectResult(
        input: [
          'IDBEL600001476<9355<<<<<<<<<<<',
          '1301014F2311207UT0130101987390',
          'SPECIMEN<<SPECIMEN<<<<<<<<<<<<',
        ],
        expectedOutput: MRZResult(
          documentType: 'ID',
          countryCode: 'BEL',
          surnames: 'SPECIMEN',
          givenNames: 'SPECIMEN',
          documentNumber: '600001476935',
          nationalityCountryCode: 'UTO',
          birthDate: DateTime(2013),
          sex: Sex.female,
          expiryDate: DateTime(2023, 11, 20),
          personalNumber: '',
          personalNumber2: '13010198739',
        ),
      ),
    );

    test(
      'document number check digit does not match throws $InvalidDocumentNumberException',
      () => expectException<InvalidDocumentNumberException>(
        input: [
          'I<SWE59000002<0198703142391<<<',
          '8703145M1701027SWE<<<<<<<<<<<8',
          'SPECIMEN<<SVEN<<<<<<<<<<<<<<<<',
        ],
      ),
    );

    test(
      'birth date check digit does not match throws $InvalidBirthDateException',
      () => expectException<InvalidBirthDateException>(
        input: [
          'I<SWE59000002<8198703142391<<<',
          '8703140M1701027SWE<<<<<<<<<<<8',
          'SPECIMEN<<SVEN<<<<<<<<<<<<<<<<',
        ],
      ),
    );

    test(
      'expiry date check digit does not match throws $InvalidExpiryDateException',
      () => expectException<InvalidExpiryDateException>(
        input: [
          'I<SWE59000002<8198703142391<<<',
          '8703145M1701020SWE<<<<<<<<<<<8',
          'SPECIMEN<<SVEN<<<<<<<<<<<<<<<<',
        ],
      ),
    );

    test(
      'final check digit does not match throws $InvalidMRZValueException',
      () => expectException<InvalidMRZValueException>(
        input: [
          'I<SWE59000002<8198703142391<<<',
          '8703145M1701027SWE<<<<<<<<<<<0',
          'SPECIMEN<<SVEN<<<<<<<<<<<<<<<<',
        ],
      ),
    );
  });

  group('TD2 passport', () {
    test(
      'correct input parses, long document number',
      () => expectResult(
        input: [
          'P<D<<MUSTERMANN<<ERIKA<<<<<<<<<<<<<<',
          'C01X00T478D<<6408125F2702283<<<<<<<4',
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
        ),
      ),
    );

    test(
      'correct input parses, short document number',
      () => expectResult(
        input: [
          'P<D<<MUSTERMANN<<ERIKA<<<<<<<<<<<<<<',
          'C01X00<<<6D<<6408125F2702283<<<<<<<8',
        ],
        expectedOutput: MRZResult(
          documentType: 'P',
          countryCode: 'D',
          surnames: 'MUSTERMANN',
          givenNames: 'ERIKA',
          documentNumber: 'C01X00',
          nationalityCountryCode: 'D',
          birthDate: DateTime(1964, 08, 12),
          sex: Sex.female,
          expiryDate: DateTime(2027, 02, 28),
          personalNumber: '',
        ),
      ),
    );

    test(
      'document number check digit does not match throws $InvalidDocumentNumberException',
      () => expectException<InvalidDocumentNumberException>(
        input: [
          'P<D<<MUSTERMANN<<ERIKA<<<<<<<<<<<<<<',
          'C01X00T470D<<6408125F2702283<<<<<<<4',
        ],
      ),
    );

    test(
      'birth date check digit does not match throws $InvalidBirthDateException',
      () => expectException<InvalidBirthDateException>(
        input: [
          'P<D<<MUSTERMANN<<ERIKA<<<<<<<<<<<<<<',
          'C01X00T478D<<6408120F2702283<<<<<<<4',
        ],
      ),
    );

    test(
      'expiry date check digit does not match rthrows $InvalidExpiryDateException',
      () => expectException<InvalidExpiryDateException>(
        input: [
          'P<D<<MUSTERMANN<<ERIKA<<<<<<<<<<<<<<',
          'C01X00T478D<<6408125F2702280<<<<<<<4',
        ],
      ),
    );

    test(
      'final check digit does not match throws $InvalidMRZValueException',
      () => expectException<InvalidMRZValueException>(
        input: [
          'P<D<<MUSTERMANN<<ERIKA<<<<<<<<<<<<<<',
          'C01X00T478D<<6408125F2702283<<<<<<<0',
        ],
      ),
    );
  });

  group('MRV-B visa', () {
    test(
      'correct input parses',
      () => expectResult(
        input: [
          'VCFINMEIKAELAEINEN<<MATTI<<<<<<<<<<<',
          '0005467<<2RUS7001017M1111019<M901101',
        ],
        expectedOutput: MRZResult(
          documentType: 'VC',
          countryCode: 'FIN',
          surnames: 'MEIKAELAEINEN',
          givenNames: 'MATTI',
          documentNumber: '0005467',
          nationalityCountryCode: 'RUS',
          birthDate: DateTime(1970),
          sex: Sex.male,
          expiryDate: DateTime(2011, 11),
          personalNumber: 'M901101',
        ),
      ),
    );

    test(
      'document number check digit does not match throws $InvalidDocumentNumberException',
      () => expectException<InvalidDocumentNumberException>(
        input: [
          'VCFINMEIKAELAEINEN<<MATTI<<<<<<<<<<<',
          '0005467<<0RUS7001017M1111019<M901101',
        ],
      ),
    );

    test(
      'birth date check digit does not match throws $InvalidBirthDateException',
      () => expectException<InvalidBirthDateException>(
        input: [
          'VCFINMEIKAELAEINEN<<MATTI<<<<<<<<<<<',
          '0005467<<2RUS7001010M1111019<M901101',
        ],
      ),
    );

    test(
      'expiry date check digit does not match throws $InvalidExpiryDateException',
      () => expectException<InvalidExpiryDateException>(
        input: [
          'VCFINMEIKAELAEINEN<<MATTI<<<<<<<<<<<',
          '0005467<<2RUS7001017M1111010<M901101',
        ],
      ),
    );
  });

  group('TD3 passport', () {
    test(
      'correct input parses, long document number',
      () => expectResult(
        input: [
          'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
          'L898902C36UTO7408122F1204159ZE184226B<<<<<10',
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
        ),
      ),
    );

    test(
      'correct input parses, shorter document number',
      () => expectResult(
        input: [
          'P<AUSMCCABE<<NICOLE<SANDRA<<<<<<<<<<<<<<<<<<',
          'L4041765<4AUS8211169F1305218<<<<<<<<<<<<<<00',
        ],
        expectedOutput: MRZResult(
          documentType: 'P',
          countryCode: 'AUS',
          surnames: 'MCCABE',
          givenNames: 'NICOLE SANDRA',
          documentNumber: 'L4041765',
          nationalityCountryCode: 'AUS',
          birthDate: DateTime(1982, 11, 16),
          sex: Sex.female,
          expiryDate: DateTime(2013, 05, 21),
          personalNumber: '',
        ),
      ),
    );

    test(
      'correct input parses, no optional data and no check digit',
      () => expectResult(
        input: [
          'I<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
          'D231458907UTO7408122F1204159<<<<<<<<<<<<<<<6',
        ],
        expectedOutput: MRZResult(
          documentType: 'I',
          countryCode: 'UTO',
          surnames: 'ERIKSSON',
          givenNames: 'ANNA MARIA',
          documentNumber: 'D23145890',
          nationalityCountryCode: 'UTO',
          birthDate: DateTime(1974, 08, 12),
          sex: Sex.female,
          expiryDate: DateTime(2012, 04, 15),
          personalNumber: '',
        ),
      ),
    );

    test(
      'document number check digit does not match throws $InvalidDocumentNumberException',
      () => expectException<InvalidDocumentNumberException>(
        input: [
          'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
          'L898902C37UTO7408122F1204159ZE184226B<<<<<10',
        ],
      ),
    );

    test(
      'birth date check digit does not match throws $InvalidBirthDateException',
      () => expectException<InvalidBirthDateException>(
        input: [
          'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
          'L898902C36UTO7408120F1204159ZE184226B<<<<<10',
        ],
      ),
    );

    test(
      'expiry date check digit does not match throws $InvalidExpiryDateException',
      () => expectException<InvalidExpiryDateException>(
        input: [
          'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
          'L898902C36UTO7408122F1204150ZE184226B<<<<<10',
        ],
      ),
    );

    test(
      'personal number check digit does not match throws $InvalidOptionalDataException',
      () => expectException<InvalidOptionalDataException>(
        input: [
          'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
          'L898902C36UTO7408122F1204159ZE184226B<<<<<00',
        ],
      ),
    );

    test(
      'final check digit does not match throws $InvalidMRZValueException',
      () => expectException<InvalidMRZValueException>(
        input: [
          'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
          'L898902C36UTO7408122F1204159ZE184226B<<<<<19',
        ],
      ),
    );
  });

  group('MRV-A visa', () {
    test(
      'correct input parses',
      () => expectResult(
        input: [
          'VNUSATRAVELER<<HAPPY<<<<<<<<<<<<<<<<<<<<<<<<',
          '12345678<8KOR5001013F1304071B3SE000IL4243934',
        ],
        expectedOutput: MRZResult(
          documentType: 'VN',
          countryCode: 'USA',
          surnames: 'TRAVELER',
          givenNames: 'HAPPY',
          documentNumber: '12345678',
          nationalityCountryCode: 'KOR',
          birthDate: DateTime(1950),
          sex: Sex.female,
          expiryDate: DateTime(2013, 04, 07),
          personalNumber: 'B3SE000IL4243934',
        ),
      ),
    );

    test(
      'document number check digit does not match throws $InvalidDocumentNumberException',
      () => expectException<InvalidDocumentNumberException>(
        input: [
          'VNUSATRAVELER<<HAPPY<<<<<<<<<<<<<<<<<<<<<<<<',
          '12345678<0KOR5001013F1304071B3SE000IL4243934',
        ],
      ),
    );

    test(
      'birth date check digit does not match throws $InvalidBirthDateException',
      () => expectException<InvalidBirthDateException>(
        input: [
          'VNUSATRAVELER<<HAPPY<<<<<<<<<<<<<<<<<<<<<<<<',
          '12345678<8KOR5001010F1304071B3SE000IL4243934',
        ],
      ),
    );

    test(
      'expiry date check digit does not match throws $InvalidExpiryDateException',
      () => expectException<InvalidExpiryDateException>(
        input: [
          'VNUSATRAVELER<<HAPPY<<<<<<<<<<<<<<<<<<<<<<<<',
          '12345678<8KOR5001013F1304070B3SE000IL4243934',
        ],
      ),
    );
  });

  group('French ID', () {
    test(
      'correct input parses',
      () => expectResult(
        input: [
          'IDFRABERTHIER<<<<<<<<<<<<<<<<<<<<<<<',
          '8806923102858CORINNE<<<<<<<6512068F6',
        ],
        expectedOutput: MRZResult(
          documentType: 'ID',
          countryCode: 'FRA',
          surnames: 'BERTHIER',
          givenNames: 'CORINNE',
          documentNumber: '880692310285',
          nationalityCountryCode: 'FRA',
          birthDate: DateTime(1965, 12, 06),
          sex: Sex.female,
          expiryDate: DateTime(1998, 06),
          personalNumber: '',
          personalNumber2: '923',
        ),
      ),
    );

    test(
      'correct input with department and office in first line parses',
      () => expectResult(
        input: [
          'IDFRABERTHIER<<<<<<<<<<<<<<<<<923255',
          '8806923102858CORINNE<<<<<<<6512068F2',
        ],
        expectedOutput: MRZResult(
          documentType: 'ID',
          countryCode: 'FRA',
          surnames: 'BERTHIER',
          givenNames: 'CORINNE',
          documentNumber: '880692310285',
          nationalityCountryCode: 'FRA',
          birthDate: DateTime(1965, 12, 06),
          sex: Sex.female,
          expiryDate: DateTime(1998, 06),
          personalNumber: '923255',
          personalNumber2: '923',
        ),
      ),
    );

    test(
      'correct input with multiple names parses',
      () => expectResult(
        input: [
          'IDFRALOISEAU<<<<<<<<<<<<<<<<<<<<<<<<',
          '970675K002774HERVE<<DJAMEL<7303216M4',
        ],
        expectedOutput: MRZResult(
          documentType: 'ID',
          countryCode: 'FRA',
          surnames: 'LOISEAU',
          givenNames: 'HERVE DJAMEL',
          documentNumber: '970675K00277',
          nationalityCountryCode: 'FRA',
          birthDate: DateTime(1973, 03, 21),
          sex: Sex.male,
          expiryDate: DateTime(2007, 06),
          personalNumber: '',
          personalNumber2: '75K',
        ),
      ),
    );

    test(
      'issued before Jan 2014 valid for 10 years',
      () => expectResult(
        input: [
          'IDFRABERTHIER<<<<<<<<<<<<<<<<<<<<<<<',
          '8806923102858CORINNE<<<<<<<6512068F6',
        ],
        expectedOutput: MRZResult(
          documentType: 'ID',
          countryCode: 'FRA',
          surnames: 'BERTHIER',
          givenNames: 'CORINNE',
          documentNumber: '880692310285',
          nationalityCountryCode: 'FRA',
          birthDate: DateTime(1965, 12, 06),
          sex: Sex.female,
          expiryDate: DateTime(1998, 06),
          personalNumber: '',
          personalNumber2: '923',
        ),
      ),
    );

    test(
      'issued after Jan 2014 for adult valid for 15 years',
      () => expectResult(
        input: [
          'IDFRABERTHIER<<<<<<<<<<<<<<<<<<<<<<<',
          '1506923102850CORINNE<<<<<<<6512068F2',
        ],
        expectedOutput: MRZResult(
          documentType: 'ID',
          countryCode: 'FRA',
          surnames: 'BERTHIER',
          givenNames: 'CORINNE',
          documentNumber: '150692310285',
          nationalityCountryCode: 'FRA',
          birthDate: DateTime(1965, 12, 06),
          sex: Sex.female,
          expiryDate: DateTime(2030, 06),
          personalNumber: '',
          personalNumber2: '923',
        ),
      ),
    );

    test(
      'issued after Jan 2014 for minor valid for 10 years',
      () => expectResult(
        input: [
          'IDFRABERTHIER<<<<<<<<<<<<<<<<<<<<<<<',
          '1506923102850CORINNE<<<<<<<0012061F6',
        ],
        expectedOutput: MRZResult(
          documentType: 'ID',
          countryCode: 'FRA',
          surnames: 'BERTHIER',
          givenNames: 'CORINNE',
          documentNumber: '150692310285',
          nationalityCountryCode: 'FRA',
          birthDate: DateTime(2000, 12, 06),
          sex: Sex.female,
          expiryDate: DateTime(2025, 06),
          personalNumber: '',
          personalNumber2: '923',
        ),
      ),
    );

    test(
      'document number check digit does not match throws $InvalidDocumentNumberException',
      () => expectException<InvalidDocumentNumberException>(
        input: [
          'IDFRABERTHIER<<<<<<<<<<<<<<<<<<<<<<<',
          '8806923102850CORINNE<<<<<<<6512068F6',
        ],
      ),
    );

    test(
      'birth date check digit does not match throws $InvalidBirthDateException',
      () => expectException<InvalidBirthDateException>(
        input: [
          'IDFRABERTHIER<<<<<<<<<<<<<<<<<<<<<<<',
          '8806923102858CORINNE<<<<<<<6512060F6',
        ],
      ),
    );

    test(
      'final check digit does not match throws $InvalidMRZValueException',
      () => expectException<InvalidMRZValueException>(
        input: [
          'IDFRABERTHIER<<<<<<<<<<<<<<<<<<<<<<<',
          '8806923102858CORINNE<<<<<<<6512068F0',
        ],
      ),
    );
  });

  group('tryParse', () {
    test(
      'invalid input returns null',
      () => expect(MRZParser.tryParse(null), null),
    );

    test(
      'correct input parses',
      () => expect(
        MRZParser.tryParse([
          'VNUSATRAVELER<<HAPPY<<<<<<<<<<<<<<<<<<<<<<<<',
          '12345678<8KOR5001013F1304071B3SE000IL4243934',
        ]),
        MRZResult(
          documentType: 'VN',
          countryCode: 'USA',
          surnames: 'TRAVELER',
          givenNames: 'HAPPY',
          documentNumber: '12345678',
          nationalityCountryCode: 'KOR',
          birthDate: DateTime(1950),
          sex: Sex.female,
          expiryDate: DateTime(2013, 04, 07),
          personalNumber: 'B3SE000IL4243934',
        ),
      ),
    );
  });
}
