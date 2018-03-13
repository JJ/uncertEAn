# For Emacs: -*- mode:cperl; mode:folding; -*-

use lib qw(../lib lib);

use v5.14;
use Test::More;
use Statistics::Basic qw(mean median);
use Number::Format qw(:subs);

use constant TESTS    => 100;

use_ok( "skewMMDP" );

my $skew = new skewMMDP(); # skewness = 0.01

isa_ok( $skew, "skewMMDP" );

my @strings;

for my $n (0..6) {
  push @strings, "0"x(6-$n) . "1"x$n;
}

for my $s (@strings) {
  my @var;
  for (my $i = 0; $i < TESTS; $i ++ ) {
    push @var,  $skew->apply( $s );
  }
  my $median = round(median(@var),6);
  my $mean = round(mean(@var),6);
  isnt( $median, $mean, "Realy skewed for $s")

}

done_testing();
