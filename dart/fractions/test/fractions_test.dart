import 'package:test/test.dart';

import 'package:fractions/fractions.dart';

void main() {
  group('toContinuedFraction', () {

    test('double', () {
      const dv = 1.53;
      expect(dv.toContinuedFraction(20, 100), equals([
        1, 1, 1, 7, 1, 4, 1, 2547284857110, 107, 1, 3, 1, 2, 1, 458428300831, 1, 2, 5, 21, 6]));
    });

    test('BigInt_based_fraction', () {
      final frac = Fraction(BigInt.from(13), BigInt.from(5));
      expect(frac.toContinuedFraction(20, 100), equals([2, 1, 1, 2]));
    });

  });

  group('toEgytianFractions', () {

    test('double', () {
      const dv = 1.56;
      expect(dv.toEgytianFractions(20), equals([2, 3, 4, 5, 6, 10, 100, 8354503656571355]));
    });

    test('BigInt_based_fraction', () {
      final frac = Fraction(BigInt.from(13), BigInt.from(5));
      expect(frac.toEgytianFractions(20), equals([2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                                                  16, 17, 18, 19, 20, 443, 332612, 140374340480]));
    });

  });
}
