library fft;

import 'package:my_complex/my_complex.dart';
import 'dart:math' as math;
import 'dart:collection';
import 'package:tuple/tuple.dart';

part 'window.dart';

typedef T Combiner<T>(T t1, T t2);
typedef T MapFunc<S, T>(int i, S s);

class FFT {
  _Twiddles _twiddles;

  List<Complex> Transform(Iterable<num> x) {
    int len = x.length;
    if (!isPowerOf2(len)) throw "length must be power of 2";
    _twiddles = new _Twiddles(len);
    var xcp = x.map((num d) => new Complex.cartesian(d, 0.0));
    return _transform(xcp, xcp.length, 1).toList(growable: false);
  }

  Iterable<Complex> _transform(Iterable<Complex> x, int length, int step) {
    if (length == 1) return x;
    int halfLength = length ~/ 2;
    var sl = new SplitList<Complex>.fromIterable(x);
    var evens = _transform(sl.evens, halfLength, step * 2);
    var odds = _transform(sl.odds, halfLength, step * 2);

    var newodds = indexedMap(odds, (i, odd)=> odd * _twiddles.at(i, length));

    var results = combineIterables(
        evens.take(halfLength), newodds.take(halfLength), (i1, i2) => i1 + i2)
      ..addAll(combineIterables(evens.take(halfLength),
          newodds.take(halfLength), (i1, i2) => i1 - i2));

    return results;
  }
}

bool isPowerOf2(int i) {
  if (i == 1) return true;
  if (i % 2 == 1) return false;
  return isPowerOf2(i ~/ 2);
}

Queue<T> indexedMap<S, T>(Iterable<S> iterable, MapFunc<S, T> mapFunc) {
  return _indexedMap(0, iterable, mapFunc);
}

Queue<T> _indexedMap<S, T>(int i, Iterable<S> iterable, MapFunc<S, T> mapFunc) {
  if (iterable.isEmpty) return new Queue();
  return _indexedMap(i+1, iterable.skip(1), mapFunc)..addFirst(mapFunc(i, iterable.first));
}

Queue<T> combineIterables<T>(
    Iterable<T> i1, Iterable<T> i2, Combiner<T> combiner) {
  if (i1.isEmpty) return new Queue.from(i2);
  if (i2.isEmpty) return new Queue.from(i1);
  return combineIterables(i1.skip(1), i2.skip(1), combiner)
    ..addFirst(combiner(i1.first, i2.first));
}

class _Twiddles {
  List<Complex> _cache;
  int _cacheLength;
  double _turn;

  _Twiddles(this._cacheLength) {
    this._cache = new List<Complex>(this._cacheLength);
    this._turn = 2 * math.PI / _cacheLength;
  }

  Complex at(int i, int length) {
    int n = i * _cacheLength ~/ length;
    if (_cache[n] == null) {
      _cache[n] = new Complex.polar(1.0, -n * _turn);
    }
    return _cache[n];
  }
}

class SplitList<T> {
  final List<T> evens;
  final List<T> odds;

  SplitList(this.evens, this.odds);

  factory SplitList.fromIterable(Iterable<T> x) {
    var t = _createSplitList(x);
    return new SplitList(t.item1.toList(), t.item2.toList());
  }

  static Tuple2<Queue<T>, Queue<T>> _createSplitList<T>(Iterable<T> x) {
    if (x.isEmpty)
      return new Tuple2<Queue<T>, Queue<T>>(new Queue<T>(), new Queue<T>());
    var t = _createSplitList(x.skip(1));
    return new Tuple2<Queue<T>, Queue<T>>(t.item2..addFirst(x.first), t.item1);
  }

  static Queue<T> _zipInternal<T>(Iterable<T> i1, Iterable<T> i2) {
    if (i1.isEmpty) return new Queue.from(i2);
    return _zipInternal(i2, i1.skip(1))..addFirst(i1.first);
  }

  List<T> zip() => _zipInternal(this.evens, this.odds).toList();
}
