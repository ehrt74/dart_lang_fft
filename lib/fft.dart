library fft;

import 'package:complex/complex.dart';
import 'dart:math' as math;
import 'dart:collection';
import 'package:tuple/tuple.dart';

part 'window.dart';

typedef T Combiner<T>(T t1, T t2);
typedef T MapFunc<S, T>(int i, S s);

class FFT {
  final _Twiddles _twiddles;

  FFT._intern(this._twiddles);

  static List<Complex> Transform(List<double> x) {
    int len = x.length;
    if (!isPowerOf2(len)) throw "length must be power of 2";
    final twiddles = _Twiddles.create(len);
    var xcp =
        x.map((double d) => Complex(d, 0.0)).toList(growable: false);
    final fft = FFT._intern(twiddles);
    return fft._transform(xcp, xcp.length, 1).toList(growable: false);
  }

  List<Complex> _transform(List<Complex> x, int length, int step) {
    if (length == 1) return x;
    int halfLength = length ~/ 2;
    var sl = new SplitList<Complex>.fromIterable(x);
    List<Complex> evens = _transform(sl.evens, halfLength, step * 2);
    List<Complex> odds = _transform(sl.odds, halfLength, step * 2);

    List<Complex> newodds =
        indexedMap(odds, (i, odd) => odd * _twiddles.at(i, length));

    var results = combineIterables<Complex>(
        evens.take(halfLength), newodds.take(halfLength), (i1, i2) => i1 + i2)
      ..addAll(combineIterables<Complex>(evens.take(halfLength),
          newodds.take(halfLength), (i1, i2) => i1 - i2));

    return results;
  }
}

bool isPowerOf2(int i) {
  if (i == 1) return true;
  if (i % 2 == 1) return false;
  return isPowerOf2(i ~/ 2);
}

List<T> indexedMap<S, T>(List<S> l, MapFunc<S, T> mapFunc) {
  List<T> ret = [];
  for (int i = 0; i < l.length; i++) {
    ret.add(mapFunc(i, l[i]));
  }
  return ret;
}

List<T> combineIterables<T>(
    Iterable<T> i1, Iterable<T> i2, Combiner<T> combiner) {
  return combineLists(
      i1.toList(growable: false), i2.toList(growable: false), combiner);
}

List<T> combineLists<T>(List<T> l1, List<T> l2, Combiner<T> combiner) {
  if (l1.length != l2.length) {
    throw "lists of different lengths";
  }
  if (l1.isEmpty) return l2;
  if (l2.isEmpty) return l1;

  List<T> ret = [];
  for (int i = 0; i < l1.length; i++) {
    ret.add(combiner(l1[i], l2[i]));
  }
  return ret;
}

class _Twiddles {
  final List<Complex> _cache;
  final int _cacheLength;

  _Twiddles(this._cacheLength, this._cache);

  factory _Twiddles.create(int cacheLength) {
    final turn = 2 * math.pi / cacheLength;
    final cache = List.generate(
        cacheLength, (i) => Complex.polar(1.0, -i * turn),
        growable: false);
    return _Twiddles(cacheLength, cache);
  }

  Complex at(int i, int length) {
    int n = i * _cacheLength ~/ length;
    return _cache[n];
  }
}

class SplitList<T> {
  final List<T> evens;
  final List<T> odds;

  SplitList(this.evens, this.odds);

  factory SplitList.fromIterable(Iterable<T> x) {
    var t = _createSplitList(x.toList(growable: false));
    return new SplitList(t.item1.toList(), t.item2.toList());
  }

  static Tuple2<List<T>, List<T>> _createSplitList<T>(List<T> x) {
    if (x.isEmpty) return new Tuple2<List<T>, List<T>>([], []);
    List<T> evens = [];
    List<T> odds = [];
    for (int i = 0; i < x.length; i += 2) {
      evens.add(x[i]);
      if (i + 1 < x.length) odds.add(x[i + 1]);
    }
    return new Tuple2<List<T>, List<T>>(evens, odds);
  }

  static Queue<T> _zipInternal<T>(Iterable<T> i1, Iterable<T> i2) {
    if (i1.isEmpty) return new Queue.from(i2);
    return _zipInternal(i2, i1.skip(1))..addFirst(i1.first);
  }

  List<T> zip() => _zipInternal(this.evens, this.odds).toList();
}
