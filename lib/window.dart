part of fft;

class Window {

  static List<num> Hann(List<num> x) {
    var len = x.length;
    var factor = 2*math.PI/(len-1);
    var ret = new List<num>(len);
    for (int i=0; i<len; i++) {
      ret[i] = 0.5 * (1 - math.cos(i*factor) ) * x[i];
    }
    return ret;
  }

  static List<num> Hamming(List<num> x) {
    var len = x.length;
    var factor = 2*math.PI/(len-1);
    var ret = new List<num>(len);
    for (int i=0; i<len; i++) {
      ret[i] = (0.54 - 0.46 * math.cos(i * factor)) * x[i];
    }
    return ret;
  }
}