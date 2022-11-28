import 'dart:math';

import 'package:args/args.dart';

import 'package:fractions/fractions.dart';

void main(List<String> args) {
  final parser = ArgParser()
      ..addOption('max-size', defaultsTo: '20')
      ..addOption('precision', defaultsTo: '100');
  final argResults = parser.parse(args);

  final maxSize = int.parse(argResults['max-size']);
  final precision = int.parse(argResults['precision']);
  for (final arg in argResults.rest) {
    List<int>? cf;
    if (arg == 'pi') {
      cf = pi.toContinuedFraction(maxSize, precision);
    } else if (arg == 'e') {
      cf = e.toContinuedFraction(maxSize, precision);
    } else {
      cf = double.tryParse(arg)?.toContinuedFraction(maxSize, precision) ??
          Fraction.tryParse(arg)?.toContinuedFraction(maxSize, precision);
    }
    if (cf != null) {
      print('$arg => $cf');
      for (var i = 0; i < cf.length; i++) {
        final curCf = cf.sublist(0, i + 1);
        final frac = Fraction.fromContinuedFraction(curCf);
        print('$curCf => $frac = ${frac.toDouble()}');
      }
    } else {
      print('Invalid number: $arg');
    }
  }
}
