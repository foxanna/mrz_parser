library mrz_parser;

import 'package:mrz_parser/mrz_result.dart';

part 'mrz_checkdigit_calculator.dart';
part 'td1_format_mrz_parser.dart';
part 'td2_format_mrz_parser.dart';
part 'td3_format_mrz_parser.dart';

class MRZParser {
  MRZParser._();

  static MRZResult parse(List<String> input) {
    if (input == null) {
      return null;
    }

    if (_TD1MRZFormat.isValidInput(input)) {
      return _TD1MRZFormat.parse(input);
    }
    if (_TD2MRZFormat.isValidInput(input)) {
      return _TD2MRZFormat.parse(input);
    }
    if (_TD3MRZFormat.isValidInput(input)) {
      return _TD3MRZFormat.parse(input);
    }

    return null;
  }
}
