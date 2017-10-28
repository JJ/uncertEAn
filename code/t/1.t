# For Emacs: -*- mode:cperl; mode:folding; -*-

use lib qw(../lib lib);

use v5.14;
use Test::More;

use constant TESTS    => 100;

use_ok( "skewMMDP" );

my $skew = new skewMMDP(); # skewness = 0.01

isa_ok( $skew, "skewMMDP" );

my @strings;

for my $n (0..6) {
  push @strings, "0"x(6-$n) . "1"x$n;
}

for my $s (@strings) {
  say "$s → ";
  for (my $i = 0; $i < TESTS; $i ++ ) {
    my $foo =  $skew->apply( $s );
    say($foo);
  }
}

done_testing();
