abstract class MRZException implements Exception {
  const MRZException(this.message);

  final String message;

  @override
  String toString() =>
      '$message. If you think this is a mistake, please file an issue '
      'https://github.com/olexale/mrz_parser/issues';
}

class InvalidMRZInputException extends MRZException {
  const InvalidMRZInputException() : super('Invalid MRZ parser input');
}

class InvalidDocumentNumberException extends MRZException {
  const InvalidDocumentNumberException()
      : super('Document number hash mismatch');
}

class InvalidBirthDateException extends MRZException {
  const InvalidBirthDateException() : super('Birth date hash mismatch');
}

class InvalidExpiryDateException extends MRZException {
  const InvalidExpiryDateException() : super('Expiry date hash mismatch');
}

class InvalidOptionalDataException extends MRZException {
  const InvalidOptionalDataException() : super('Optional data hash mismatch');
}

class InvalidMRZValueException extends MRZException {
  const InvalidMRZValueException() : super('Final hash mismatch');
}
