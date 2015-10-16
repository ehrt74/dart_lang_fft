part of fft;


class _WindowType {
  String name;
  
  static _WindowType HANN = new _WindowType.intern("Hann");
  static _WindowType HAMMING = new _WindowType.intern("Hamming");

  _WindowType.intern(this.name);

}

class Window {

  static Map<_WindowType, Map<int, List<num>>> _cache = new Map<_WindowType, Map<int, List<num>>>();

  static bool _factorsCached(_WindowType type, int len) {
    if(!_cache.containsKey(type)) {
      _cache[type] = new Map<int, List<num>>();
      return false;
    }
    if(!_cache[type].containsKey(len)) {
      return false;
    }
    return true;
  }

  static List<num>_getCached(_WindowType type, int len) {
    return _cache[type][len];
  }
  
  static List<num> _apply(List<num> factors, List<num> x) {
    var len = factors.length;
    var ret = new List<num>(len);
    for (int i = 0; i<len; i++) {
      ret[i] = factors[i] * x[i];
    }
    return ret;
  }
  
  static List<num> Hann(List<num> x) {
    var type = _WindowType.HANN;
    if(!_factorsCached(type, x.length)) {
      var len = x.length;
      var factors = new List<num>(len);
      var factor = 2*math.PI/(len-1);
      for (int i=0; i<len; i++)
        factors[i] = 0.5 * (1 - math.cos(i*factor));
      _cache[type][len] = factors;
    }
    return _apply(_getCached(type, x.length), x);
  }

  static List<num> Hamming(List<num> x) {
    var type = _WindowType.HAMMING;
    if(!_factorsCached(type, x.length)) {
      var len = x.length;
      var factors = new List<num>(len);
      var factor = 2*math.PI/(len-1);
      for (int i=0; i<len; i++)
        factors[i] = 0.54 - 0.46 * math.cos(i*factor);
      _cache[type][len] = factors;
    }
    return _apply(_getCached(type, x.length), x);
  }
}