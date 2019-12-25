library mrz_parser;

import 'package:mrz_parser/mrz_result.dart';

/// A MRZ parser.
class MRZParser {
  MRZParser._();

  static MRZResult parse(List<String> input) {
    if (input == null) {
      return null;
    }
    return const MRZResult();
  }
}
