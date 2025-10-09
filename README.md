# mrz_parser (Dart/Flutter) 
[![Coverage Status](https://coveralls.io/repos/github/foxanna/mrz_parser/badge.svg?branch=master)](https://coveralls.io/github/foxanna/mrz_parser?branch=master)

Parse MRZ (Machine Readable Zone) from identity documents. Heavily
inspired by [QKMRZParser](https://github.com/Mattijah/QKMRZParser).

### Supported formats:
* TD1
* TD2
* TD3
* MRV-A
* MRV-B

## Usage

### Import the package
Add to `pubspec.yaml`
```yaml
dependencies:
    mrz_parser: ^2.0.0
```

### Parse MRZ
```dart
final mrz = [
  'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
  'L898902C36UTO7408122F1204159ZE184226B<<<<<10'
];

final result = MRZParser.tryParse(mrz);

// Alternatively use parse and catch MRZException descendants
try {
  final result = MRZParser.parse(mrz);
} on MRZException catch(e) {
  print(e);
}
```

### Parse Driver License
```dart
final driverLicense = [
  'D1NLD11234567890ABCDEFGHIJKLM7'
];

final result = DriverLicenseParser.tryParse(driverLicense);

// Alternatively use parse and catch MRZException descendants
try {
  final result = DriverLicenseParser.parse(driverLicense);
  print(result.documentNumber); // 1234567890
  print(result.countryCode); // NLD
} on MRZException catch(e) {
  print(e);
}
```

## Benchmarks

Performance benchmarks for parsing different MRZ formats:

| Format | Type | Average Parse Time |
|--------|------|-------------------|
| TD3 | Passport | ~103.34 µs |
| TD2 | ID Card | ~13.81 µs |
| TD1 | ID Card | ~15.67 µs |
| Driver License | Driver License | ~16.33 µs |

Run benchmarks yourself:
```bash
dart run benchmark/mrz_parser_benchmark.dart
```

## Authors
* [Anna Domashych](https://github.com/foxanna/)
* [Oleksandr Leuschenko](https://github.com/olexale/)

## License
`mrz_parser` is released under a [MIT License](https://opensource.org/licenses/MIT). See `LICENSE` for details.
