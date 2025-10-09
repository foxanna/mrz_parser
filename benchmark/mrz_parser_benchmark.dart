// ignore_for_file: avoid_print

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:mrz_parser/mrz_parser.dart';

// TD3 format (passports)
class TD3ParseBenchmark extends BenchmarkBase {
  const TD3ParseBenchmark() : super('MRZ Parser TD3 (Passport)');

  static const List<String> mrz = [
    'P<UTOERIKSSON<<ANNA<MARIA<<<<<<<<<<<<<<<<<<<',
    'L898902C36UTO7408122F1204159ZE184226B<<<<<10',
  ];

  @override
  void run() {
    MRZParser.tryParse(mrz);
  }
}

// TD2 format (ID cards)
class TD2ParseBenchmark extends BenchmarkBase {
  const TD2ParseBenchmark() : super('MRZ Parser TD2 (ID Card)');

  static const List<String> mrz = [
    'I<UTOD231458907ABC<<<<<<<<<<<<',
    '7408122F1204159UTO<<<<<<<<<<<6',
  ];

  @override
  void run() {
    MRZParser.tryParse(mrz);
  }
}

// TD1 format (ID cards)
class TD1ParseBenchmark extends BenchmarkBase {
  const TD1ParseBenchmark() : super('MRZ Parser TD1 (ID Card)');

  static const List<String> mrz = [
    'I<UTOD23145890<<<<<<<<<<<<<<<<',
    '7408122F1204159UTO<<<<<<<<<<<6',
    'ERIKSSON<<ANNA<MARIA<<<<<<<<<<<',
  ];

  @override
  void run() {
    MRZParser.tryParse(mrz);
  }
}

// Driver License format
class DriverLicenseParseBenchmark extends BenchmarkBase {
  const DriverLicenseParseBenchmark() : super('Driver License Parser');

  static const List<String> mrz = [
    'D1NLD11234567890ABCDEFGHIJKLM7',
  ];

  @override
  void run() {
    DriverLicenseParser.tryParse(mrz);
  }
}

void main() {
  const TD3ParseBenchmark().report();
  const TD2ParseBenchmark().report();
  const TD1ParseBenchmark().report();
  const DriverLicenseParseBenchmark().report();
}
