part of fft;

class ComplexPolar {
  double angle;
  double length;
  static final double MATH2PI = 2*math.PI;
  
  ComplexPolar(num length, num angle) {
    length = length.toDouble();
    angle = angle.toDouble(); 
    if (length<0) {
      angle+=math.PI;
      length=-length;
    }
    this.length = length;
    this.angle = angle%(MATH2PI);
  }

  ComplexPolar.fromComplex(Complex c) {
    if (c.real==0.0 || c.imaginary==0.0) {
      if(c.imaginary==0.0) {
        this.length = c.real;
        this.angle = 0.0;
      }
      if(c.real ==0.0) {
        this.length = c.imaginary;
        this.angle = math.PI/2;
      }
      if (length<0) {
        this.length *= -1;
        this.angle += math.PI;
      }
      if (this.angle>MATH2PI)
        this.angle -= MATH2PI;
      return;
    }
    length = c.real * math.sqrt(1 + math.pow( (c.imaginary/c.real), 2));
    if (length<0) length = -length;
//    var length = math.sqrt(math.pow(c.real, 2) + math.pow(c.imaginary, 2));
    angle = math.atan2(c.imaginary, c.real);
    if (angle<0) angle+=MATH2PI;
    //    return new ComplexPolar(length, angle);
  }

  String toString() {
    return "(r:${this.length}, θ:${this.angle})";
  }

  double get imaginary=>this.length * math.sin(this.angle); //complex.imaginary;
  double get real=>this.length * math.cos(this.angle); //complex.real;
  
  ComplexPolar operator +(ComplexPolar other) {
    return new ComplexPolar.fromComplex(this.complex + other.complex);
  }

  ComplexPolar operator *(ComplexPolar other) {
    return new ComplexPolar(this.length * other.length, this.angle+other.angle);
  }

  void timesClobber(ComplexPolar other) {
    this.length *= other.length;
    this.angle += other.angle;
    if (this.angle > MATH2PI)
      this.angle -= MATH2PI;
  }
  
  ComplexPolar operator -(ComplexPolar other) {
    return new ComplexPolar.fromComplex(this.complex - other.complex);
  }

  ComplexPolar operator /(ComplexPolar other) {
    return new ComplexPolar(this.length / other.length, this.angle-other.angle);
  }

  num divideClobber(ComplexPolar other) {
    this.length /= other.length;
    this.angle = (this.angle - other.angle)%MATH2PI;
  }
  
  ComplexPolar turn(num other) {
    return new ComplexPolar(this.length, this.angle + other);
  }

  void turnClobber(num other) {
    this.angle = (this.angle + other)%MATH2PI;
  }

  ComplexPolar pow(num factor) {
    return new ComplexPolar(math.pow(this.length, factor), this.angle*factor);
  }

  void powClobber(num factor) {
    this.length = math.pow(this.length, factor);
    this.angle = (this.angle * factor)%MATH2PI;
  }

  ComplexPolar stretch(num factor) {
    return new ComplexPolar(this.length*factor, this.angle);
  }

  void stretchClobber(num factor) {
    if(factor<0) {
      this.length *= -factor;
      this.angle = -this.angle;
    } else {
      this.length *= factor;
    }
  }
  

  ComplexPolar invert() {
    return new ComplexPolar(1/this.length, -this.angle);
  }

  void invertClobber() {
    this.length = 1/this.length;
    this.angle = MATH2PI - this.angle;
  }
  
  Complex get complex=>new Complex(this.length * math.cos(this.angle), this.length * math.sin(this.angle));

}
