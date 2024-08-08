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

## Authors
* [Anna Domashych](https://github.com/foxanna/)
* [Oleksandr Leuschenko](https://github.com/olexale/)

## License
`mrz_parser` is released under a [MIT License](https://opensource.org/licenses/MIT). See `LICENSE` for details.
