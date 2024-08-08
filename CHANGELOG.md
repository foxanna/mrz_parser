## [2.0.1]

* Implements new ICAO9303 part 5 long document numbers for TD1 (by @nicoinn)
* Support Dart 3, while maintaining backward compatibility with Dart 2 (by @tomasaquiles-ca)

## [2.0.0]

* Support null-safety

## [1.2.0]

* French Id format support

## [1.1.0]

Improvements:

* Make `MRZParser.parse()` throw meaningful instances of `MRZException`
* Support documents with document number shorted than 9 characters
  ([#2](https://github.com/olexale/mrz_parser/issues/2))

New features:

* Provide `MRZParser.tryParse()` method which returns `null` if parsing
  was unsuccessful

## [1.0.0] - First release

First release with following formats:
* TD1
* TD2
* TD3
* MRV-A
* MRV-B
