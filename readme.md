Math-Window2Viewport
====================
Just another window to viewport mapper.

Synopsis
--------
```perl
use Math::Window2Viewport;

my $mapper = Math::Window2Viewport->new(
    Wb => 0, Wt => 1, Wl => 0, Wr => 1,
    Vb => 9, Vt => 0, Vl => 0, Vr => 9,
);

my ($x, $y) = (0.5, 0.6);
my $x2 = $mapper->Dx( $x );
my $y2 = $mapper->Dy( $y );

```

Examples
--------
The following images were generated with a [supplied tool](/examples/bin/graph.pl):

  Sine wave:
![sine wave](/examples/sine.png)

  Sawtooth wave:
![sawtooth wave](/examples/sawtooth.png)

  Triangle wave:
![triangle wave](/examples/triangle.png)

  Square wave:
![square wave](/examples/square.png)

  Fourier synthesized square wave:
![Fourier sqaure](/examples/fsquare.png)

Installation
------------
To install this module, you should use CPAN. A good starting
place is [How to install CPAN modules](http://www.cpan.org/modules/INSTALL.html).

If you truly want to install from this github repo, then
be sure and create the manifest before you test and install:
```
perl Makefile.PL
make
make manifest
make test
make install
```

Support and Documentation
-------------------------
After installing, you can find documentation for this module with the
perldoc command.
```
perldoc Spreadsheet::HTML
```
You can also find documentation at [metaCPAN](https://metacpan.org/pod/Math::Window2Viewport).

License and Copyright
---------------------
See [source POD](/lib/Math/Window2Viewport.pm).
