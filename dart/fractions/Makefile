.PHONY: default test benchmark

default: bin/to_continued_fraction.exe bin/to_egyptian_fractions.exe

bin/to_continued_fraction.exe: bin/to_continued_fraction.dart lib/fractions.dart
	dart compile exe bin/to_continued_fraction.dart

bin/to_egyptian_fractions.exe: bin/to_egyptian_fractions.dart lib/fractions.dart
	dart compile exe bin/to_egyptian_fractions.dart

test:
	dart run test

benchmark:
	dart run benchmark
