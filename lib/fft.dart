library fft;

import 'package:complex/complex.dart';
import 'dart:math' as math;

part 'complex_polar.dart';
part 'window.dart';

class FFT {

  _Twiddles _twiddles;
  
  List<Complex> Transform(List<num> x) {
    _twiddles = new _Twiddles(x.length);
    var xcp = x.map((num d)=>new ComplexPolar(d, 0)).toList();
    var result =  _transform(xcp, xcp.length, 1);
    return result.map((ComplexPolar cp)=>cp.complex).toList();
  }

  List<ComplexPolar> _transform(List<ComplexPolar> x, int length, int step) {
    //    print(x);
    if (length==1) return x;
    int halfLength = length~/2;
    if (length%2 != 0) {
      throw "length must be power of 2";
    }
    var sl = new SplitList<ComplexPolar>.fromList(x);
    var results = new List<ComplexPolar>();
    var evens = _transform(sl.evens, halfLength, step*2);
    var odds = _transform(sl.odds, halfLength, step*2);
    var newodds = new List<ComplexPolar>(halfLength);
    for (int n=0; n<odds.length; n++) newodds[n] = odds[n].turn(_twiddles.at(n, length).angle);
      
    for (int i= 0; i<halfLength; i++) {
      results.add(evens[i] + newodds[i]);
    }
    for (int i=0; i<halfLength; i++) {
      results.add(evens[i] - newodds[i]);
    }
    return results;
  }
}

class _Twiddles {
  List<ComplexPolar> _cache;
  int _cacheLength;
  
  _Twiddles(this._cacheLength) {
    this._cache = new List<ComplexPolar>(this._cacheLength);
  }

  ComplexPolar at(int i, int length) {
    int n = i*_cacheLength~/length;
    if (_cache[n]==null) {
      _cache[n] = new ComplexPolar(1, n * 2 * math.PI/_cacheLength);
    }
    return _cache[n];
  }
}

class SplitList<T> {
  List<T> evens;
  List<T> odds;

  SplitList.fromList(List<T> x) {
    odds = new List<T>();
    evens = new List<T>();
    for (int i =0; i<x.length; i++) {
      i%2==0? evens.add(x[i]): odds.add(x[i]);
    }
  }

  SplitList(this.evens, this.odds);

  List<T> zip() {
    var ret = new List<T>(2*evens.length);
    for (int i=0; i< evens.length; i++) {
      ret[2*i] = evens[i];
      ret[2*i + 1] = odds[i];
    }
    return ret;
  }
}