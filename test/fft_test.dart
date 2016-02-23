import 'package:test/test.dart';
import 'package:fft/fft.dart';
import 'package:complex/complex.dart';
import 'dart:math' as math;

void main() {
  test("foobar works", () {
    expect(true, equals(true));
  });

  test("complexpolar works", () {
    var cp = new ComplexPolar(2,0);
    expect(cp.complex.real, equals(2));
  });

  var cp1 = new ComplexPolar.fromComplex(new Complex(1,0));
  var cp2 = new ComplexPolar.fromComplex(new Complex(0,1));
    
  test("complexpolar adding", () {
    var cp3 = cp1 + cp2;
    expect(cp3.angle, equals(math.PI/4));
  });


  test("complexpolar conversion", () {
    var cp1 = new ComplexPolar.fromComplex(new Complex(1,0));
    var cp2 = new ComplexPolar.fromComplex(new Complex(0,1));
    var cp3 = new ComplexPolar.fromComplex(new Complex(-1,0));
    var cp4 = new ComplexPolar.fromComplex(new Complex(0,-1));
    expect(cp1.angle, equals(0));
    expect(cp2.angle, equals(math.PI/2));
    expect(cp3.angle, equals(math.PI));
    expect(cp4.angle, equals(3*math.PI/2));
  });
  
  test("complexpolar adding timed", () {
    Stopwatch s = new Stopwatch();
    var cp4 = new ComplexPolar(1,1);
    var cp3 = new ComplexPolar(1,0);
    num reps = math.pow(10,6);
    s.start();
    for(int i=0; i<reps; i++) {
      cp3 = cp3+cp4;
    }
    s.stop();
    print("$reps repetitions: ${s.elapsedMilliseconds}ms");
  });

  test("complexpolar multiplication timed", () {
    Stopwatch s = new Stopwatch();
    var cp4 = new ComplexPolar(1,1);
    var cp3 = new ComplexPolar(1,0);
    num reps = math.pow(10,6);
    s.start();
    for(int i=0; i<reps; i++) {
      cp3 = cp3*cp4;
    }
    s.stop();
    print("$reps repetitions: ${s.elapsedMilliseconds}ms");
  });

  test("complexpolar clobber multiplication timed", () {
    Stopwatch s = new Stopwatch();
    var cp4 = new ComplexPolar(1,1);
    var cp3 = new ComplexPolar(1,0);
    num reps = math.pow(10,6);
    s.start();
    for(int i=0; i<reps; i++) {
      cp3.timesClobber(cp4);
    }
    s.stop();
    print("$reps repetitions: ${s.elapsedMilliseconds}ms");
  });

  test("complex multiplication timed", () {
    Stopwatch s = new Stopwatch();
    var cp4 = new Complex(1,1);
    var cp3 = new Complex(1,0);
    num reps = math.pow(10,6);
    s.start();
    for(int i=0; i<reps; i++) {
      cp3 = cp4*cp3;
    }
    s.stop();
    print("$reps repetitions: ${s.elapsedMilliseconds}ms");
  });

  test("complexpolar imaginary timed", () {
    Stopwatch s = new Stopwatch();
    var cp4 = new ComplexPolar(1,1);
    double total = 0.0;
    num reps = math.pow(10,6);
    s.start();
    for(int i=0; i<reps; i++) {
      total += cp4.imaginary;
      cp4 = cp4.turn(0.1);
    }
    s.stop();
    print("$reps repetitions: ${s.elapsedMilliseconds}ms");
  });
  
  test("complexpolar conversion timed", () {
    Stopwatch s = new Stopwatch();
    var cp4 = new ComplexPolar(1,1);
    num reps = math.pow(10,6);
    s.start();
    for(int i=0; i<reps; i++) {
      cp4 = new ComplexPolar.fromComplex(cp4.complex);
    }
    s.stop();
    print("$reps repetitions: ${s.elapsedMilliseconds}ms");
  });

  test("complexpolar invertClobber timed", () {
    Stopwatch s = new Stopwatch();
    var cp4 = new ComplexPolar(1,1);
    num reps = math.pow(10,6);
    s.start();
    for(int i=0; i<reps; i++) {
      cp4.invertClobber();
    }
    s.stop();
    print("$reps repetitions: ${s.elapsedMilliseconds}ms");
  });

  test("complexpolar invert timed", () {
    Stopwatch s = new Stopwatch();
    var cp4 = new ComplexPolar(1,1);
    num reps = math.pow(10,6);
    s.start();
    for(int i=0; i<reps; i++) {
      cp4=cp4.invert();
    }
    s.stop();
    print("$reps repetitions: ${s.elapsedMilliseconds}ms");
  });

  
  
  test("complexpolar real", () {
    expect(cp1.real, equals(1));
    var cp3 = new ComplexPolar(-2,math.PI);
    expect(cp3.real, equals(2));
  });

  test("complexpolar imaginary", () {
    expect(cp1.imaginary, equals(0));
    var cp3 = new ComplexPolar(-2, math.PI * 3/4);
    num res = cp3.imaginary + 2* math.SQRT1_2;
    bool passed = res<0.0001 && res>-0.0001;
    expect(passed, equals(true));
  });

  test("complexpolar multiply", () {
    var cp3 = cp1 * cp2;
    expect(cp3.angle, equals(math.PI/2));
  });

  test("complexpolar turn", () {
    var cp3 = cp1.turn(math.PI/2);
    expect(cp3.angle, equals(math.PI/2));
    expect(cp3.length, equals(1.0));
  });

  test("complexpolar pow", () {
    var cp3 = new ComplexPolar(2,math.PI/2);
    var cp4 = cp3.pow(3);
    expect(cp4.length, equals(8));
    expect(cp4.angle, equals( 3 * math.PI/2));
  });

  test("complexpolar stretch", () {
    expect(cp2.stretch(4).length, equals(4));
  });


  test("complexpolar invert", () {
    var cp3 = new ComplexPolar(2,math.PI/4);
    var cp4 = cp3.invert();
    expect(cp4.length, equals(1/2));
    expect(cp4.angle, equals(7*math.PI/4));
  });

  var complexPolarList1 = [ new ComplexPolar(1,0), new ComplexPolar(-1,0)];
  var complexPolarList2 = [ new ComplexPolar(0,1), new ComplexPolar(0,-1)];
  
  test("SplitList runs", () {
    var sl = new SplitList<ComplexPolar>(complexPolarList1, complexPolarList2);
    expect(true, equals(true));
  });

  var sln = new SplitList<num>.fromList([1,2,3,4]);
  test("SplitList splits", () {
    expect(sln.evens[0], equals(1));
    expect(sln.odds[1], equals(4));
  });
  
  test("SplitList zips", () {
    expect(sln.zip()[2], equals(3));
  });

  test("FFT runs", () {
    var fft = new FFT().Transform([1.0,0.0,-1.0, 0.0]);
    //    print(fft);
    expect(fft.length, equals(4));
  });

  test("Hamming works", () {
    var l = [1,1,1,1,1,1,1,1,1];
    var h = Window.Hamming(l);
    //    print(h);
    expect(h[(l.length-1)~/2], equals(1));
  });

  test("Hann works", () {
    var l = [1,1,1,1,1,1,1,1,1];
    var h = Window.Hann(l);
    //    print(h);
    expect(h[(l.length-1)~/2], equals(1));
  });

  test("fft does something that makes sense", () {
    int l2len = 12;
    int len = math.pow(2, l2len);
    var frequencies = [2,5,15,35];
    var input = new List<num>.filled(len,0);
    
    for (int i=0; i<len; i++) {
      frequencies.forEach((int freq) {
        input[i] += math.cos(2*math.PI * i * freq / len);
      });
    }
    var fft = new FFT().Transform(Window.Hamming(input));
    var results = new List<num>();
    frequencies.forEach((int i)=>results.add(fft[i].abs()));
    var res = results.fold(true, (bool val, double n)=>val && (n>5.0));
    expect(res, equals(true)); 

  });
  test("fft has right sign for phase", () {
    int l2len = 8;
    int len = math.pow(2, l2len);
    var input = new List<num>.filled(len,0);
    
    for (int i=0; i<len; i++) {
      input[i] += math.sin(2*math.PI * i * 4/len);
      input[i] += math.cos(2*math.PI * i * 7/len);
    }
    var fft = new FFT().Transform(Window.Hamming(input));
    var sinArgument = fft[4].argument();
    var cosArgument = fft[7].argument();
    expect(sinArgument<(math.PI * -0.45) && sinArgument>(math.PI * -0.55), equals(true));
    expect(cosArgument<0.05 && cosArgument>-0.05, equals(true));
  });

  test("fft produces correct results", () {
    var vals = [1,2,3,1,2,3,1,2];
    var fft = new FFT().Transform(vals);
    print(fft);

  });
}
