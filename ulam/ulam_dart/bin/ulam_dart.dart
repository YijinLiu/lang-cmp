// To compile  dart compile exe -p find_ulam/.dart_tool/package_config.json ulam.dart
// 653807 us used to find 7584 Ulam numbers <= 100000.

import 'dart:io';

import 'package:args/args.dart';

bool isUlamNumber(int n, List<int> ulamNumbers) {
    var i = 0;
    var j = ulamNumbers.length - 1;
    var fnd = false;
    while (i < j) {
        final sum = ulamNumbers[i] + ulamNumbers[j];
        if (sum == n) {
            if (fnd) return false;
            fnd = true;
            i++;
            j--;
        } else if (sum < n) {
            i++;
        } else {
            j--;
        }
    }
    return fnd;
}

const limitOpt = 'limit';
const outputCsvOpt = 'output-csv';

void main(List<String> arguments) {
    final parser = ArgParser()..addOption(limitOpt, abbr: 'l', defaultsTo: '100000')
                              ..addOption(outputCsvOpt, abbr: 'o', defaultsTo: 'ulam_100k_dart.csv');
    ArgResults argResults = parser.parse(arguments);
    final limit = int.parse(argResults[limitOpt]);
    final outputCsv = argResults[outputCsvOpt];

    var ulamNumbers = <int>[1, 2];
    var elapsedUsList = <int>[0, 0];
    var startUs = DateTime.now().microsecondsSinceEpoch;
    int totalElapsedUs = 0;
    for (int i = 3; i <= limit; i++) {
        if (isUlamNumber(i, ulamNumbers)) {
            final elapsedUs = DateTime.now().microsecondsSinceEpoch - startUs;
            print('${elapsedUs} us used to find Ulam number ${i}.');
            totalElapsedUs += elapsedUs;
            startUs = DateTime.now().microsecondsSinceEpoch;
            ulamNumbers.add(i);
            elapsedUsList.add(elapsedUs);
        }
    }
    totalElapsedUs += DateTime.now().microsecondsSinceEpoch - startUs;
    print('${totalElapsedUs} us used to find ${ulamNumbers.length} Ulam numbers <= ${limit}.');
    var csvFile = File(outputCsv);
    var csvSink = csvFile.openWrite();
    csvSink.write('ulam_num,elapsed_ns\n');
    for (int i = 0; i < ulamNumbers.length; i++) {
        csvSink.write('${ulamNumbers[i]},${elapsedUsList[i]*1000}\n');
    }
    csvSink.close();
}
