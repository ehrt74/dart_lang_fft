import 'package:test/test.dart';
import 'package:fft/fft.dart';

main() {

  test("SplitList constructor works", () {
    List<int> myList = [1,2,3,4,5];
    var split = new SplitList.fromIterable(myList);

    expect([1,3,5], equals(split.evens));
    expect([2,4], equals(split.odds));
  });

  test("SplitList constructor works with even length", () {
    List<int> myList = [1,2,3,4];
    var split = new SplitList.fromIterable(myList);

    expect([1,3], equals(split.evens));
    expect([2,4], equals(split.odds));
  });

  test("zip works", () {
    List<int> myList = [1,2,3,4,5];
    var split = new SplitList.fromIterable(myList);

    var orig = split.zip();

    expect(myList, equals(orig));
  });
}