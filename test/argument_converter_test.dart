import 'package:ray_dart/src/argument_converter.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Convert values', () {
    test('returns null for null values', () {
      expect(convertToPrimitive(null), isNull);
    });

    test('returns int values unchanged', () {
      expect(convertToPrimitive(1), 1);
      expect(convertToPrimitive(double.infinity), double.infinity);
    });

    test('returns string values unchanged', () {
      expect(convertToPrimitive('test string'), 'test string');
      expect(convertToPrimitive(''), '');
    });

    test('returns bool values unchanged', () {
      expect(convertToPrimitive(true), isTrue);
      expect(convertToPrimitive(false), isFalse);
    });
  });
}
