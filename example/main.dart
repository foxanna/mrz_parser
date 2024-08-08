// ignore_for_file: avoid_print

import 'package:mrz_parser/mrz_parser.dart';

void main() {
  final mrz = [
    'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
    'L898902C36UTO7408122F1204159ZE184226B<<<<<10',
  ];

  final result = MRZParser.tryParse(mrz);

  print(result?.documentType); // 'P'
  print(result?.countryCode); // 'UTO'
  print(result?.surnames); // 'ERIKSSON'
  print(result?.givenNames); // 'ANNA MARIA'
  print(result?.documentNumber); // 'L898902C3'
  print(result?.nationalityCountryCode); // 'UTO'
  print(result?.birthDate); // DateTime(1974, 08, 12)
  print(result?.sex); // Sex.female
  print(result?.expiryDate); // DateTime(2012, 04, 15)
  print(result?.personalNumber); // 'ZE184226B'
  print(result?.personalNumber2); // null
}
