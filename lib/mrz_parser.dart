library mrz_parser;

import 'package:mrz_parser/mrz_result.dart';

part 'mrz_format.dart';
class MRZParser {
  MRZParser._();

  static MRZResult parse(List<String> input) {
    if (!_isValidInput(input)) {
      return null;
    }

    switch (_getMRZFormat(input)) {
      case _MRZFormat.td1:
        break;
      case _MRZFormat.td2:
        break;
      case _MRZFormat.td3:
        break;
      default:
        return null;
    }

    return const MRZResult();
  }

  static bool _isValidInput(List<String> input) =>
      input != null && (input.length == 2 || input.length == 3);

  static _MRZFormat _getMRZFormat(List<String> input) {
    switch (input.length) {
      case 2:
        return _MRZFormat.unknown;
      case 3:
        return _MRZFormat.unknown;
      default:
        return _MRZFormat.unknown;
    }
  }
}
