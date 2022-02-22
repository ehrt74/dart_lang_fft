import 'dart:math' as math;
import 'dart:io';

import 'package:test/test.dart';
import 'package:fft/fft.dart';
import 'package:complex/complex.dart';

void main() {
  test("combine iterables works", () {
    var l1 = [0, 2, 4, 6];
    var l2 = [1, 3, 5, 7];

    expect(combineLists(l1, l2, (dynamic i1, dynamic i2) => i1 + i2), equals([1, 5, 9, 13]));
    expect(combineLists(l1, l2, (dynamic i1, dynamic i2) => i1 - i2), equals([-1, -1, -1, -1]));
  });

  test("indexed map works", () {
    var l1 = new List.filled(10, 1);
    var l2 = indexedMap(l1, (i, dynamic x) => i * x);
    expect(l2, equals(new Iterable.generate(10, (i) => i)));
  });

  test("FFT runs", () {
    var fft = new FFT().Transform([1.0, 0.0, -1.0, 0.0]);
    //    print(fft);
    expect(fft.length, equals(4));
  });

  test("Hamming works", () {
    var h = WindowType.HAMMING;
    var factors = h.getFactors(8);
    var goldenCopy = [0.08, 0.25, 0.64, 0.95, 0.95, 0.64, 0.25, 0.08];

    expect(factors.length, equals(8));
    for (int i = 0; i < 8; i++)
      expect(factors.toList()[i],
          inInclusiveRange(goldenCopy[i] - 0.01, goldenCopy[i] + 0.01));
  });

  test("Hann works", () {
    var h = WindowType.HANN;
    var factors = h.getFactors(8);
    var goldenCopy = [0.0, 0.19, 0.61, 0.95, 0.95, 0.61, 0.19, 0.0];

    expect(factors.length, equals(8));
    for (int i = 0; i < 8; i++)
      expect(factors.toList()[i],
          inInclusiveRange(goldenCopy[i] - 0.01, goldenCopy[i] + 0.01));
  });

  test("fft does something that makes sense", () {
    int l2len = 12;
    int len = math.pow(2, l2len) as int;
    var frequencies = [2, 5, 15, 35];
    var input = new List<num>.filled(len, 0);

    for (int i = 0; i < len; i++) {
      frequencies.forEach((int freq) {
        input[i] += math.cos(2 * math.pi * i * freq / len);
      });
    }

    var window = new Window(WindowType.HAMMING);
    var fft = new FFT().Transform(window.apply(input));
    var results = <num>[];
    frequencies.forEach((int i) => results.add(fft[i]!.abs()));
    var res = results.fold(true, (bool val, num n) => val && (n > 5.0));
    expect(res, equals(true));
  });

  double _getValAt(int i, int len) =>
      math.sin(2 * math.pi * i * 4 / len) + math.cos(2 * math.pi * i * 7 / len);

  test("fft has right sign for phase", () {
    int l2len = 8;
    int len = math.pow(2, l2len) as int;
    var input = new Iterable.generate(len, (i) => _getValAt(i, len)).toList();

    List<Complex?> fft = new FFT().Transform(input);

    var sinSignal = fft[4]!;
    var cosSignal = fft[7]!;

    expect(sinSignal.argument().abs(),
        inExclusiveRange(math.pi * 0.48, math.pi * 0.52));
    expect(cosSignal.argument(), inExclusiveRange(-0.05, 0.05));

    expect(sinSignal.abs(), inExclusiveRange(len * 0.48, len * 0.52));
    expect(cosSignal.abs(), inExclusiveRange(len * 0.48, len * 0.52));
  });

  test("fft works for large samples", () {
    int l2len = 18;
    int len = math.pow(2, l2len) as int;
    var input = (new Iterable.generate(len, (i) => _getValAt(i, len))).toList();

    List<num> windowed = new Window(WindowType.HAMMING).apply(input);

    List<Complex?> fft = new FFT().Transform(windowed);
  });
}
