#!/usr/bin/env perl

use Test::More;

use lib qw( lib ../lib ../../lib ../../CPAN/Algorithm-Evolutionary/lib ../../../CPAN/Algorithm-Evolutionary/lib ../../../../../../../CPAN/Algorithm-Evolutionary/lib ); #Just in case we are testing it in-place

use Math::Random qw(random_normal);

BEGIN {
  use_ok( 'Algorithm::Evolutionary::Individual::NoisyBitString' );
  use_ok( 'Algorithm::Evolutionary::Op::MutationWithNoise' );
}

diag( "Testing UncertEAn $Algorithm::Evolutionary::VERSION, Perl $], $^X" );

my $pop = 100;
my $length = 30;

my @many_skewnesses = random_normal( $pop, 0, 2);
my @many_sds = map( abs($_), random_normal( $pop, 0, 0.1) );
my $m = new Algorithm::Evolutionary::Op::MutationWithNoise;
isa_ok( $m, Algorithm::Evolutionary::Op::MutationWithNoise );

for ( my $p = 0; $p < 100; $p++ ) {
  my $this_u = new Algorithm::Evolutionary::Individual::NoisyBitString $length, pop @many_skewnesses, pop @many_sds;
  isa_ok( $this_u, Algorithm::Evolutionary::Individual::NoisyBitString);
  my $new_one = $m->apply( $this_u);
  for my $k (qw( _str _normal_sigma _skewness )) {
    isnt( $this_u->{$k}, $new_one->{$k}, "Mutated $k OK");
  }
}
  


done_testing();
