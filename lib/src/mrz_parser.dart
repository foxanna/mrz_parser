library mrz_parser;

import 'package:mrz_parser/src/mrz_result.dart';

part 'mrz_checkdigit_calculator.dart';
part 'mrz_field_formatter.dart';
part 'mrz_string_extensions.dart';
part 'td1_format_mrz_parser.dart';
part 'td2_format_mrz_parser.dart';
part 'td3_format_mrz_parser.dart';

class MRZParser {
  MRZParser._();

  static MRZResult parse(List<String> input) {
    input = _polishInput(input);
    if (input == null) {
      return null;
    }

    if (_TD1MRZFormatParser.isValidInput(input)) {
      return _TD1MRZFormatParser.parse(input);
    }
    if (_TD2MRZFormatParser.isValidInput(input)) {
      return _TD2MRZFormatParser.parse(input);
    }
    if (_TD3MRZFormatParser.isValidInput(input)) {
      return _TD3MRZFormatParser.parse(input);
    }

    return null;
  }

  static List<String> _polishInput(List<String> input) {
    if (input == null) {
      return null;
    }

    input = input.map((s) => s?.toUpperCase()).toList();

    return input.any((s) => !s.isValidMRZInput) ? null : input;
  }
}
