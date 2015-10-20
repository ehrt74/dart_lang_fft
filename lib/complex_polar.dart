part of fft;

class ComplexPolar {
  num angle;
  num length;

  ComplexPolar(num length, num angle) {
    if (length<0) {
      angle+=math.PI;
      length=-length;
    }
    this.length = length;
    this.angle = angle%(2 * math.PI);
  }

  factory ComplexPolar.fromComplex(Complex c) {
    var length = math.sqrt(math.pow(c.real, 2) + math.pow(c.imaginary, 2));
    var angle = math.atan2(c.imaginary, c.real);
    return new ComplexPolar(length, angle);
  }

  String toString() {
    return "(r:${this.length}, θ:${this.angle})";
  }

  num get imaginary=>this.complex.imaginary;
  num get real=>this.complex.real;
  
  ComplexPolar operator +(ComplexPolar other) {
    return new ComplexPolar.fromComplex(this.complex + other.complex);
  }
  
  ComplexPolar operator *(ComplexPolar other) {
    return new ComplexPolar(this.length * other.length, this.angle+other.angle);
  }

  ComplexPolar operator -(ComplexPolar other) {
    return new ComplexPolar.fromComplex(this.complex - other.complex);
  }

  ComplexPolar operator /(ComplexPolar other) {
    return new ComplexPolar(this.length / other.length, this.angle-other.angle);
  }
  
  ComplexPolar turn(num other) {
    return new ComplexPolar(this.length, this.angle + other);
  }

  ComplexPolar pow(num factor) {
    return new ComplexPolar(math.pow(this.length, factor), this.angle*factor);
  }

  ComplexPolar stretch(num factor) {
    return new ComplexPolar(this.length*factor, this.angle);
  }

  Complex get complex=>new Complex(this.length * math.cos(this.angle), this.length * math.sin(this.angle));

}
