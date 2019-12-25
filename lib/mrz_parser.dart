library mrz_parser;

import 'package:mrz_parser/mrz_result.dart';

part 'mrz_format.dart';
class MRZParser {
  MRZParser._();

  static MRZResult parse(List<String> input) {
    if (input == null) {
      return null;
    }
    return const MRZResult();
  }
}
