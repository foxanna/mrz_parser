import 'package:mrz_parser/mrz_parser.dart';
import 'package:test/test.dart';

void main() {
  test('fixes document type', () {
    expect(MRZFieldRecognitionDefectsFixer.fixDocumentType('V'), 'V');
    expect(MRZFieldRecognitionDefectsFixer.fixDocumentType('P<<'), 'P<<');
    expect(MRZFieldRecognitionDefectsFixer.fixDocumentType('0128'), 'OIZB');
    expect(MRZFieldRecognitionDefectsFixer.fixDocumentType('<'), '<');
  });

  test('fixes check digit', () {
    expect(MRZFieldRecognitionDefectsFixer.fixCheckDigit('8'), '8');
    expect(MRZFieldRecognitionDefectsFixer.fixCheckDigit('<6<'), '<6<');
    expect(MRZFieldRecognitionDefectsFixer.fixCheckDigit('0QUDIZB'), '0000128');
    expect(MRZFieldRecognitionDefectsFixer.fixCheckDigit('<'), '<');
  });

  test('fixes date', () {
    expect(MRZFieldRecognitionDefectsFixer.fixDate('190213'), '190213');
    expect(MRZFieldRecognitionDefectsFixer.fixDate('19021<'), '19021<');
    expect(MRZFieldRecognitionDefectsFixer.fixDate('0QUDIZB'), '0000128');
    expect(MRZFieldRecognitionDefectsFixer.fixDate('<'), '<');
  });

  test('fixes sex', () {
    expect(MRZFieldRecognitionDefectsFixer.fixSex('M'), 'M');
    expect(MRZFieldRecognitionDefectsFixer.fixSex('F'), 'F');
    expect(MRZFieldRecognitionDefectsFixer.fixSex('P'), 'F');
    expect(MRZFieldRecognitionDefectsFixer.fixSex('<'), '<');
  });

  test('fixes country code', () {
    expect(MRZFieldRecognitionDefectsFixer.fixCountryCode('UA'), 'UA');
    expect(MRZFieldRecognitionDefectsFixer.fixCountryCode('D<<'), 'D<<');
    expect(MRZFieldRecognitionDefectsFixer.fixCountryCode('0128'), 'OIZB');
    expect(MRZFieldRecognitionDefectsFixer.fixCountryCode('<'), '<');
  });

  test('fixes names', () {
    expect(
      MRZFieldRecognitionDefectsFixer.fixNames('<SURNAME<<'),
      '<SURNAME<<',
    );
    expect(MRZFieldRecognitionDefectsFixer.fixNames('D<<'), 'D<<');
    expect(MRZFieldRecognitionDefectsFixer.fixNames('0128'), 'OIZB');
    expect(MRZFieldRecognitionDefectsFixer.fixNames('<'), '<');
  });

  test('fixes nationality', () {
    expect(MRZFieldRecognitionDefectsFixer.fixNationality('UA'), 'UA');
    expect(MRZFieldRecognitionDefectsFixer.fixNationality('D<<'), 'D<<');
    expect(MRZFieldRecognitionDefectsFixer.fixNationality('0128'), 'OIZB');
    expect(MRZFieldRecognitionDefectsFixer.fixNationality('<'), '<');
  });
}
