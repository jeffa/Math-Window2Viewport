#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Math::Window2Viewport' ) || print "Bail out!\n";
}

diag( "Testing Math::Window2Viewport $Math::Window2Viewport::VERSION, Perl $], $^X" );
