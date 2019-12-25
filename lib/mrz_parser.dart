library mrz_parser;

import 'package:mrz_parser/mrz_result.dart';

part 'td1_format_mrz_parser.dart';

class MRZParser {
  MRZParser._();

  static MRZResult parse(List<String> input) {
    if (!_isValidInput(input)) {
      return null;
    }

    }

    return const MRZResult();
  }

  static bool _isValidInput(List<String> input) =>
      input != null && (input.length == 2 || input.length == 3);

  static _MRZFormat _getMRZFormat(List<String> input) {
    }
  }
}
