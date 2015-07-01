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
$width  ||= 400;
$height ||= 300;
$res    ||= .01;

my %waves = (
    sine        => \&sine,
    square      => \&square,
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

    my (%curr,%prev);
    for (my $x = $mapper->{Wl}; $x <= $mapper->{Wr}; $x += $res) {
        my $y = sin( $x );
        %curr = ( dx => $mapper->Dx( $x ), dy => $mapper->Dy( $y ) );
        $img->moveTo( @prev{qw(dx dy)} );
        $img->lineTo( @curr{qw(dx dy)} );
        %prev = %curr;
    }
    return $img->png;
}

sub sawtooth {
    my ($width,$height,$res) = @_;
    my $img = GD::Simple->new( $width, $height );
    my $mapper = Math::Window2Viewport->new(
        Wb => -1, Wt => 1, Wl => 0, Wr => 4,
        Vb => $height, Vt => 0, Vl => 0, Vr => $width,
    );

    my (%curr,%prev);
    for (my $x = $mapper->{Wl}; $x <= $mapper->{Wr}; $x += $res) {
        my $tmp = $x / $mapper->{Wr} * 2 * 1.618;
        my $y = 1 * ( $tmp - floor( $tmp ) );
        %curr = ( dx => $mapper->Dx( $x ), dy => $mapper->Dy( $y ) );
        $img->moveTo( @prev{qw(dx dy)} );
        $img->lineTo( @curr{qw(dx dy)} );
        %prev = %curr;
    }
    return $img->png;
}

sub triangle {
    my ($width,$height,$res) = @_;
    my $img = GD::Simple->new( $width, $height );
    my $mapper = Math::Window2Viewport->new(
        Wb => -1, Wt => 1, Wl => 0, Wr => 4,
        Vb => $height, Vt => 0, Vl => 0, Vr => $width,
    );

    my (%curr,%prev);
    for (my $x = $mapper->{Wl}; $x <= $mapper->{Wr}; $x += $res) {
        my $y = (2 / 3.1459 ) * asin( sin( $x * 3.1459 ) );
        %curr = ( dx => $mapper->Dx( $x ), dy => $mapper->Dy( $y ) );
        $img->moveTo( @prev{qw(dx dy)} );
        $img->lineTo( @curr{qw(dx dy)} );
        %prev = %curr;
    }
    return $img->png;
}

sub square {
    my ($width,$height,$res) = @_;
    my $img = GD::Simple->new( $width, $height );
    my $mapper = Math::Window2Viewport->new(
        Wb => -1, Wt => 1, Wl => 0, Wr => 4,
        Vb => $height, Vt => 0, Vl => 0, Vr => $width,
    );

    my (%curr,%prev);
    for (my $x = $mapper->{Wl}; $x <= $mapper->{Wr}; $x += $res) {
        my $y = 0;
        for (my $i = 1; $i < 20; $i += 2) {
            $y += 1 / $i * cos( 2 * 3.1459 * $i * $x + ( -3.1459 / 2 ) );
        }
        %curr = ( dx => $mapper->Dx( $x ), dy => $mapper->Dy( $y ) );
        $img->moveTo( @prev{qw(dx dy)} );
        $img->lineTo( @curr{qw(dx dy)} );
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

B<This program> 

=cut

