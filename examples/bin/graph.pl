#!/usr/bin/env perl 

use strict;
use warnings;
use Pod::Usage;
use Getopt::Long;

use POSIX;
use GD::Simple;
use Math::Trig qw( asin );
use Math::Window2Viewport;

GetOptions (
    'wave=s'    => \my $wave,
    'width=i'   => \my $width,
    'height=i'  => \my $height,
    'res=s'     => \my $res,
    help        => \my $help,
    man         => \my $man,
);
pod2usage( -verbose => 0 ) if $help;
pod2usage( -verbose => 2 ) if $man;

$wave   ||= 'sine';
$width  ||= 200;
$height ||= 150;
$res    ||= .01;

my %waves = (
    sine        => \&sine,
    square      => \&square,
    fsquare     => \&fsquare,
    sawtooth    => \&sawtooth,
    triangle    => \&triangle,
);

my $sub = $waves{$wave} ? $waves{$wave} : $waves{sine};
print $sub->( $width, $height, abs( $res ) );


sub sine {
    my ($width,$height,$res) = @_;
    my $img = GD::Simple->new( $width, $height );
    my $mapper = Math::Window2Viewport->new(
        Wb => -1, Wt => 1, Wl => 0, Wr => 3.1459 * 2,
        Vb => $height, Vt => 0, Vl => 0, Vr => $width,
    );

    return _graph_it( $mapper, GD::Simple->new( $width, $height ), $res, sub { sin( $_[0] ) } );
}

sub sawtooth {
    my ($width,$height,$res) = @_;
    my $img = GD::Simple->new( $width, $height );
    my $mapper = Math::Window2Viewport->new(
        Wb => 0, Wt => 1, Wl => 0, Wr => 4,
        Vb => $height, Vt => 0, Vl => 0, Vr => $width,
    );

    my $sub = sub {
        my $tmp = $_[0] / $mapper->{Wr} * 2 * 1.618;
        return 1 * ( $tmp - floor( $tmp ) );
    };

    return _graph_it( $mapper, GD::Simple->new( $width, $height ), $res, $sub );
}

sub triangle {
    my ($width,$height,$res) = @_;
    my $img = GD::Simple->new( $width, $height );
    my $mapper = Math::Window2Viewport->new(
        Wb => -1, Wt => 1, Wl => 0, Wr => 4,
        Vb => $height, Vt => 0, Vl => 0, Vr => $width,
    );

    my $sub = sub {
        return (2 / 3.1459 ) * asin( sin( $_[0] * 3.1459 ) );
    };

    return _graph_it( $mapper, GD::Simple->new( $width, $height ), $res, $sub );
}

sub square {
    my ($width,$height,$res) = @_;
    my $img = GD::Simple->new( $width, $height );
    my $mapper = Math::Window2Viewport->new(
        Wb => -2, Wt => 2, Wl => 0, Wr => 4,
        Vb => $height, Vt => 0, Vl => 0, Vr => $width,
    );

    my $sign = sub { $_[0] >= 0 ? ($_[0] == 0 ? 0 : 1) : -1 };
    my $sub = sub {
        return .9 * $sign->( sin( 2 * 3.1459 * ( $_[0] - .5 ) / $mapper->{Wr} * 2 ) );
    };

    return _graph_it( $mapper, GD::Simple->new( $width, $height ), $res, $sub );
}


sub fsquare {
    my ($width,$height,$res) = @_;
    my $mapper = Math::Window2Viewport->new(
        Wb => -1, Wt => 1, Wl => 0, Wr => 4,
        Vb => $height, Vt => 0, Vl => 0, Vr => $width,
    );

    my $sub = sub { 
        my $y = 0;
        for (my $i = 1; $i < 20; $i += 2) {
            $y += 1 / $i * cos( 2 * 3.1459 * $i * $_[0] + ( -3.1459 / 2 ) );
        }
        $y;
    };

    return _graph_it( $mapper, GD::Simple->new( $width, $height ), $res, $sub );
}


sub _graph_it {
    my ($mapper,$img,$res,$y_val) = @_;

    my (%curr,%prev);
    for (my $x = $mapper->{Wl}; $x <= $mapper->{Wr}; $x += $res) {
        my $y = $y_val->( $x );
        %curr = ( dx => $mapper->Dx( $x ), dy => $mapper->Dy( $y ) );
        if (keys %prev) {
            $img->moveTo( @prev{qw(dx dy)} );
            $img->lineTo( @curr{qw(dx dy)} );
        } else {
            $img->moveTo( @curr{qw(dx dy)} );
        }
        %prev = %curr;
    }
    return $img->png;
}


# for GD
# sudo apt-get -y install libgd2-xpm-dev build-essential


__END__
=head1 NAME

graph.pl - 

=head1 SYNOPSIS

graph.pl [options]

 Options:
   --wave           sine or sqaure
   --height         height of PNG output
   --width          width of PNG output
   --res            resolution of wave
   --help           list usage
   --man            print man page

=head1 OPTIONS

=over 8

=item B<--wave>

The waveform to draw. Current options are:

  sin
  square

=item B<--height>

The height (in pixels) of the PNG output.

=item B<--width>

The width (in pixels) of the PNG output.

=item B<--res>

The resolution of the waveform. Values between
0 and 1 work best.

=item B<--help>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<This program> will produce a waveform in PNG format
on request.

=cut
