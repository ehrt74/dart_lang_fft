import 'package:fft/fft.dart';

import 'package:test/test.dart';


bool equalIterables<E>(Iterable<E> i1, Iterable<E> i2) {
  if (i1.isEmpty || i2.isEmpty)
    return i1.isEmpty && i2.isEmpty;
  if (i1.first.hashCode!=i2.first.hashCode)
    return false;
  return equalIterables(i1.skip(1), i2.skip(1));
}

main() {
  test("Window caches results", () {
    Window window = new Window(WindowType.NONE);
    List<num> values = new Iterable.generate(16, (i)=>i).toList();
    Iterable<num> results = window.apply(values);
    expect(values, equals(results));

  });

  test("Multiply lists works", () {
    Window window = new Window(WindowType.NONE);
    int len = 20000;
    List<num> values1 = new Iterable.generate(len, (i)=>i).toList();
    List<num> values2 = new Iterable.generate(len, (i)=>len-i).toList();
    Iterable<num> expected = new Iterable.generate(len, (i)=>i * (len-i));
    expect(window.multiplyLists(values1, values2), equals(expected));
  });
}