import 'package:fft/fft.dart';

import 'package:test/test.dart';

bool equalIterables<E>(Iterable<E> i1, Iterable<E> i2) {
  if (i1.isEmpty || i2.isEmpty) return i1.isEmpty && i2.isEmpty;
  if (i1.first.hashCode != i2.first.hashCode) return false;
  return equalIterables(i1.skip(1), i2.skip(1));
}

main() {
  test("Window caches results", () {
    Window window = new Window(WindowType.NONE);
    List<double> values = List.generate(16, (i) => i.toDouble(), growable:false);
    Iterable<num> results = window.apply(values);
    expect(values, equals(results));
  });

  test("Multiply lists works", () {
    Window window = new Window(WindowType.NONE);
    int len = 20000;
    List<double> values1 = List.generate(len, (i) => i.toDouble(), growable: false);
    List<double> values2 = List.generate(len, (i) => (len - i).toDouble(), growable: false);
    Iterable<num> expected = new Iterable.generate(len, (i) => i * (len - i));
    expect(window.multiplyLists(values1, values2), equals(expected));
  });
}
