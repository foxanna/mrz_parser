import 'package:mrz_parser/src/mrz_driver_license_result.dart';
import 'package:mrz_parser/src/mrz_exceptions.dart';
import 'package:mrz_parser/src/mrz_parser.dart' as mrz_parser;

class DriverLicenseParser {
  DriverLicenseParser._();

  static const _lineLength = 30;

  /// Parse [input] and return [MRZDriverLicenseResult] instance.
  ///
  /// Like [parse] except that this function returns `null` where a
  /// similar call to [parse] would throw a [MRZException]
  /// in case of invalid input or unsuccessful parsing
  static MRZDriverLicenseResult? tryParse(List<String?>? input) {
    try {
      return parse(input);
    } on Exception {
      return null;
    }
  }

  /// Parse [input] and return [MRZDriverLicenseResult] instance.
  ///
  /// The [input] must be a non-null non-empty List with a single line
  /// from a driver license machine-readable zone.
  ///
  /// If [input] format is invalid or parsing was unsuccessful,
  /// an instance of [MRZException] is thrown
  static MRZDriverLicenseResult parse(List<String?>? input) {
    final polishedInput = _polishInput(input);
    if (polishedInput == null || polishedInput.isEmpty) {
      throw const InvalidMRZInputException();
    }

    if (polishedInput.length != 1 || polishedInput[0].length != _lineLength) {
      throw const InvalidMRZInputException();
    }

    if (!polishedInput[0].startsWith('D')) {
      throw const InvalidMRZInputException();
    }

    return mrz_parser.parseDriverLicense(polishedInput[0]);
  }

  static List<String>? _polishInput(List<String?>? input) {
    if (input == null) {
      return null;
    }

    final polishedInput =
        input.where((s) => s != null).map((s) => s!.toUpperCase()).toList();

    final validMRZInput = RegExp(r'^[A-Z|0-9|<]+$');
    return polishedInput.any((s) => !validMRZInput.hasMatch(s))
        ? null
        : polishedInput;
  }
}
