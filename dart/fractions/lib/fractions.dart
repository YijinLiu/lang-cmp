import 'dart:math';

extension Fractions on double {
  List<int> toEgytianFractions(int precision) {
    if (this <= 0) return List.empty();

    var result = <int>[];
    var num = this;
    var denonimator = 1;
    var maxDenominator = pow(10, precision);
    do {
      denonimator++;
      final fraction = 1 / denonimator;
      if (num >= fraction) {
        result.add(denonimator);
        num -= fraction;
      } else {
        break;
      }
    } while (denonimator < maxDenominator);

    while (num > 0) {
      denonimator = (1 / num).ceil();
      if (denonimator > maxDenominator) break;
      num -= 1 / denonimator;
      if (num.isNegative) break;
      result.add(denonimator);
    }

    return result;
  }

  List<int> toContinuedFraction(int maxSize, int precision) {
    if (this <= 0) return List.empty();
    final epsilon = pow(10.0, -precision);
    var result = <int>[];
    var num = this;
    do {
        final i = num.floor();
        result.add(i);
        num -= i;
        if (num < epsilon) break;
        num = 1 / num;
    } while (result.length < maxSize);
    return result;
  }
}

extension LargestCommonMultiple on BigInt {
    BigInt lcm(BigInt other) {
        return this * other ~/ this.gcd(other);
    }
}

class Fraction implements Comparable<Fraction> {
  BigInt _numerator;
  BigInt _denominator;

  Fraction(this._numerator, this._denominator)
      : assert(!_numerator.isNegative && _denominator.sign == 1);

  Fraction.fromInt(int iv) : this(BigInt.from(iv), BigInt.one);

  Fraction.zero() : this.fromInt(0);

  static Fraction? tryParse(String str) {
    final items = str.split('/');
    if (items.length != 2) return null;
    final numerator = BigInt.tryParse(items[0]);
    if (numerator == null) return null;
    final denominator = BigInt.tryParse(items[1]);
    if (denominator == null) return null;
    return Fraction(numerator, denominator);
  }

  static Fraction fromContinuedFraction(List<int> cf) {
      Fraction? frac;
      for (final denominator in cf.reversed) {
          var newFrac = Fraction(BigInt.from(denominator), BigInt.one);
          if (frac != null) newFrac.add(frac..reverse());
          frac = newFrac;
      }
      if (frac != null) return frac;
      return Fraction.zero();
  }

  double toDouble() => _numerator / _denominator;

  String toString() => '$_numerator/$_denominator';

  void reverse() {
      final temp = _numerator;
      _numerator = _denominator;
      _denominator = temp;
  }

  void add(Fraction other) {
    final newDen = _denominator.lcm(other._denominator);
    final newNum = _numerator * (newDen ~/ _denominator) +
        other._numerator * (newDen ~/ other._denominator);
    final gcd = newDen.gcd(newNum);
    _numerator = newNum ~/ gcd;
    _denominator = newDen ~/ gcd;
  }

  void subtract(Fraction other) {
    final newDen = _denominator.lcm(other._denominator);
    final newNum = _numerator * (newDen ~/ _denominator) -
        other._numerator * (newDen ~/ other._denominator);
    assert(!newNum.isNegative);
    final gcd = newDen.gcd(newNum);
    _numerator = newNum ~/ gcd;
    _denominator = newDen ~/ gcd;
  }

  @override
  int compareTo(Fraction other) {
    final newDen = _denominator.lcm(other._denominator);
    return (_numerator * (newDen ~/ _denominator)).compareTo(
        other._numerator * (newDen ~/ other._denominator));
  }

  List<int> toContinuedFraction(int maxSize, int precision) {
    var result = <int>[];
    var numerator = _numerator;
    var denominator = _denominator;
    final maxMultiple = BigInt.from(10).pow(precision);
    do {
        final i = numerator ~/ denominator;
        result.add(i.toInt());
        final temp = numerator % denominator;
        if (temp * maxMultiple < denominator) break;
        numerator = denominator;
        denominator = temp;
    } while (result.length < maxSize);
    return result;
  }

  List<int> toEgytianFractions(int precision) {
    var result = <int>[];
    var frac = Fraction(_numerator, _denominator);
    final maxDenominator = pow(10, precision);
    for (var i = 2; i <= maxDenominator; i++) {
      final temp = Fraction(BigInt.one, BigInt.from(i));
      if (frac.compareTo(temp) >= 0) {
        frac.subtract(temp);
        result.add(i);
      } else {
        break;
      }
    }

    final biMaxDenominator = BigInt.from(10).pow(precision);
    while (frac._numerator.sign == 1) {
      final den = (frac._denominator + frac._numerator - BigInt.one) ~/ frac._numerator;
      if (den > biMaxDenominator) break;
      frac.subtract(Fraction(BigInt.one, den));
      result.add(den.toInt());
    }

    return result;
  }
}

