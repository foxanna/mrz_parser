library mrz_parser;

import 'package:mrz_parser/src/mrz_exceptions.dart';
import 'package:mrz_parser/src/mrz_result.dart';

part 'mrz_checkdigit_calculator.dart';
part 'mrz_field_parser.dart';
part 'mrz_field_recognition_defects_fixer.dart';
part 'mrz_string_extensions.dart';
part 'td1_format_mrz_parser.dart';
part 'td2_format_mrz_parser.dart';
part 'td3_format_mrz_parser.dart';

class MRZParser {
  MRZParser._();

  /// Parse [input] and return [MRZResult] instance.
  ///
  /// Like [parse] except that this function returns `null` where a
  /// similar call to [parse] would throw a [MRZException]
  /// in case of invalid input or unsuccessful parsing
  static MRZResult? tryParse(List<String?>? input) {
    try {
      return parse(input);
    } on Exception {
      return null;
    }
  }

  /// Parse [input] and return [MRZResult] instance.
  ///
  /// The [input] must be a non-null non-empty List of lines
  /// from a documents machine-readable zone.
  ///
  /// If [input] format is invalid or parsing was unsuccessful,
  /// an instance of [MRZException] is thrown
  static MRZResult parse(List<String?>? input) {
    final polishedInput = _polishInput(input);
    if (polishedInput == null) {
      throw const InvalidMRZInputException();
    }

    if (_TD1MRZFormatParser.isValidInput(polishedInput)) {
      return _TD1MRZFormatParser.parse(polishedInput);
    }
    if (_TD2MRZFormatParser.isValidInput(polishedInput)) {
      return _TD2MRZFormatParser.parse(polishedInput);
    }
    if (_TD3MRZFormatParser.isValidInput(polishedInput)) {
      return _TD3MRZFormatParser.parse(polishedInput);
    }

    throw const InvalidMRZInputException();
  }

  static List<String>? _polishInput(List<String?>? input) {
    if (input == null) {
      return null;
    }

    final polishedInput =
        input.where((s) => s != null).map((s) => s!.toUpperCase()).toList();

    return polishedInput.any((s) => !s.isValidMRZInput) ? null : polishedInput;
  }
}
