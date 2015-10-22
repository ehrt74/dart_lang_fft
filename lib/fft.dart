library fft;

import 'package:complex/complex.dart';
import 'package:complex/fastmath.dart' as fastmath;
import 'dart:math' as math;

part 'complex_polar.dart';
part 'window.dart';

class FFT {

  _Twiddles _twiddles;
  
  List<Complex> Transform(List<num> x) {
    _twiddles = new _Twiddles(x.length);
    var xcp = x.map((num d)=>new Complex(d, 0)).toList();
    return  _transform(xcp, xcp.length, 1);
  }

  List<ComplexPolar> TransformAsComplexPolar(List<num> x) {
    return Transform(x).map((Complex c)=>new ComplexPolar.fromComplex(c)).toList();
  }
  
  List<Complex> _transform(List<Complex> x, int length, int step) {
    //    print(x);
    if (length==1) return x;
    int halfLength = length~/2;
    if (length%2 != 0) {
      throw "length must be power of 2";
    }
    var sl = new SplitList<Complex>.fromList(x);
    var results = new List<Complex>();
    var evens = _transform(sl.evens, halfLength, step*2);
    var odds = _transform(sl.odds, halfLength, step*2);
    var newodds = new List<Complex>(halfLength);
    for (int n=0; n<odds.length; n++) newodds[n] = odds[n] * _twiddles.at(n, length);
      
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
  List<Complex> _cache;
  int _cacheLength;
  double _turn;
  
  _Twiddles(this._cacheLength) {
    this._cache = new List<Complex>(this._cacheLength);
    this._turn = 2 * math.PI/_cacheLength;
  }

  Complex at(int i, int length) {
    int n = i*_cacheLength~/length;
    if (_cache[n]==null) {
      _cache[n] = new ComplexPolar(1, -n * _turn).complex; //2 * math.PI/_cacheLength);
      //      _cache[n] = new ComplexPolar(1, n * 2 * math.PI/_cacheLength);
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