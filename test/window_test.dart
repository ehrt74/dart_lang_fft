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
    Iterable<num> values = new Iterable.generate(16, (i)=>i);
    Iterable<num> results = window.apply(values);
    expect(values, equals(results));

  });
}