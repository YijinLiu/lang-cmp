import 'package:benchmark/benchmark.dart';

import 'package:fractions/fractions.dart';

void main() {
  group('toContinuedFraction', () {

    benchmark('double', () {
      for (final dv in [0.37, 0.78, 0.92, 1.26, 1.53, 1.82, 2.56, 3.1, 5.2, 7.63]) {
        dv.toContinuedFraction(20, 100);
      }
    });

    benchmark('BigInt_based_fraction', () {
      final frac_list = [
        Fraction(BigInt.from(1), BigInt.from(3)),
        Fraction(BigInt.from(2), BigInt.from(5)),
        Fraction(BigInt.from(7), BigInt.from(13)),
        Fraction(BigInt.from(9), BigInt.from(8)),
        Fraction(BigInt.from(11), BigInt.from(7)),
        Fraction(BigInt.from(19), BigInt.from(11)),
        Fraction(BigInt.from(19), BigInt.from(7)),
        Fraction(BigInt.from(21), BigInt.from(5)),
        Fraction(BigInt.from(37), BigInt.from(7)),
        Fraction(BigInt.from(41), BigInt.from(6)),
      ];
      for (final frac in frac_list) {
        frac.toContinuedFraction(20, 100);
      }
    });

  });

  group('toEgytianFractions', () {

    benchmark('double', () {
      for (final dv in [0.37, 0.78, 0.92, 1.26, 1.53, 1.82, 2.56, 3.1, 5.2, 7.63]) {
        dv.toEgytianFractions(20);
      }
    });

    benchmark('BigInt_based_fraction', () {
      final frac_list = [
        Fraction(BigInt.from(1), BigInt.from(3)),
        Fraction(BigInt.from(2), BigInt.from(5)),
        Fraction(BigInt.from(7), BigInt.from(13)),
        Fraction(BigInt.from(9), BigInt.from(8)),
        Fraction(BigInt.from(11), BigInt.from(7)),
        Fraction(BigInt.from(19), BigInt.from(11)),
        Fraction(BigInt.from(19), BigInt.from(7)),
        Fraction(BigInt.from(21), BigInt.from(5)),
        Fraction(BigInt.from(37), BigInt.from(7)),
        Fraction(BigInt.from(41), BigInt.from(6)),
      ];
      for (final frac in frac_list) {
        frac.toEgytianFractions(20);
      }
    });

  });
}
