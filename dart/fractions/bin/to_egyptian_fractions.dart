import 'dart:math';

import 'package:args/args.dart';

import 'package:fractions/fractions.dart';

void main(List<String> args) {
  final parser = ArgParser()
      ..addOption('precision', defaultsTo: '20');
  final argResults = parser.parse(args);

  final precision = int.parse(argResults['precision']);
  for (final arg in argResults.rest) {
    List<int>? ef;
    if (arg == 'pi') {
      ef = pi.toEgytianFractions(precision);
    } else if (arg == 'e') {
      ef = e.toEgytianFractions(precision);
    } else {
      ef = double.tryParse(arg)?.toEgytianFractions(precision) ??
          Fraction.tryParse(arg)?.toEgytianFractions(precision);
    }
    if (ef != null) {
      print('$arg => $ef');
      var dv = 0.0;
      var frac = Fraction(BigInt.zero, BigInt.one);
      for (var i = 0; i < ef.length; i++) {
        dv += 1 / ef[i];
        frac.add(Fraction(BigInt.one, BigInt.from(ef[i])));
        print('${ef.sublist(0, i + 1)} => $frac = $dv');
      }
    } else {
      print('Invalid number: $arg');
    }
  }
}
