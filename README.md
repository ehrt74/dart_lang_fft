# dart

An implementation of Cooley-Tukey. Also included are the windowing functions Hann and Hamming

## Usage

A simple usage example:

    import 'package:fft/fft.dart';

    main() {
    	   var data = [1.0, 0.0, -1.0, 0.0];
	   var windowed = Window.Hann(data);
    	   var fft = new FFT().Transform(windowed);
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
