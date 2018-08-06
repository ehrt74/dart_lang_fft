part of fft;


abstract class WindowType {
  String name;
  
  static WindowType HANN = new HannWindowType._intern();
  static WindowType HAMMING = new HammingWindowType._intern();
  static WindowType NONE = new NoWindowType._intern();

  WindowType._intern(this.name);

  Iterable<num> getFactors(int len);

}

class HannWindowType extends WindowType {

  HannWindowType._intern():super._intern("hann");

  Iterable<num> getFactors(int len) {
    var factors = new List<num>(len);
    var factor = 2*math.pi/(len-1);
    for (int i=0; i<len; i++)
      factors[i] = 0.5 * (1 - math.cos(i*factor));
    return factors;
  }
}

class NoWindowType extends WindowType {

  NoWindowType._intern():super._intern("No window");

  Iterable<num> getFactors(int len) {
    return new Iterable.generate(len, (i)=>1);
  }
}

class HammingWindowType extends WindowType {

  HammingWindowType._intern():super._intern("Hamming");

  Iterable<num> getFactors(int len) {
    var factors = new List<num>(len);
    var factor = 2 * math.pi / (len - 1);
    for (int i = 0; i < len; i++)
      factors[i] = 0.54 - 0.46 * math.cos(i * factor);
    return factors;
  }
}


class Window {

  final WindowType windowType;

  Map<int, List<num>> cache = new Map<int, List<num>>();

  Window(this.windowType);

  List<num> multiplyLists(List<num> factors, List<num> x) {
    if (factors.length != x.length) {
        throw "lists of different lengths";
    }
    if (factors.isEmpty)
      return [];
    List<num> ret = new List(factors.length);
    for (int i=0; i<ret.length; i++) {
      ret[i] = factors[i] * x[i];
    }
    return ret;
  }

  List<num> apply(List<num> x) {
    int len = x.length;
    if(!cache.containsKey(len))
      cache[len] = windowType.getFactors(len).toList(growable:false);
    return multiplyLists(cache[len], x);
  }
}