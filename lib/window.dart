part of fft;

abstract class WindowType {
  String name;

  static WindowType HANN = new HannWindowType._intern();
  static WindowType HAMMING = new HammingWindowType._intern();
  static WindowType NONE = new NoWindowType._intern();

  WindowType._intern(this.name);

  List<double> getFactors(int len);
}

class HannWindowType extends WindowType {
  HannWindowType._intern() : super._intern("hann");

  List<double> getFactors(int len) {
    var factor = 2 * math.pi / (len - 1);
    return List.generate(len, (i) => 0.5 * (1 - math.cos(i * factor)), growable: false);
  }
}

class NoWindowType extends WindowType {
  NoWindowType._intern() : super._intern("No window");

  List<double> getFactors(int len) {
    return List.generate(len, (i) => 1);
  }
}

class HammingWindowType extends WindowType {
  HammingWindowType._intern() : super._intern("Hamming");

  List<double> getFactors(int len) {
    var factor = 2 * math.pi / (len - 1);
    var factors = List.generate(len, (i) => 0.54 - 0.46 * math.cos(i * factor),
        growable: false);
    return factors;
  }
}

class Window {
  final WindowType windowType;

  Map<int, List<double>> cache = new Map<int, List<double>>();

  Window(this.windowType);

  List<double> multiplyLists(List<double> factors, List<double> x) {
    if (factors.length != x.length) {
      throw "lists of different lengths";
    }
    if (factors.isEmpty) return [];
    List<double> ret = List.generate(factors.length, (i) => factors[i] * x[i],
        growable: false);
    return ret;
  }

  List<double> apply(List<double> x) {
    int len = x.length;
    return multiplyLists(
        cache.putIfAbsent(
            len, () => windowType.getFactors(len)),
        x);
  }
}
