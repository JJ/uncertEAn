#!/usr/bin/env perl

use Test::More;

use lib qw( lib ../lib ../../lib ../../CPAN/Algorithm-Evolutionary/lib ../../../CPAN/Algorithm-Evolutionary/lib ../../../../../../../CPAN/Algorithm-Evolutionary/lib ); #Just in case we are testing it in-place

BEGIN {
	use_ok( 'Algorithm::Evolutionary::Individual::NoisyBitString' );
}

diag( "Testing UncertEAn $Algorithm::Evolutionary::VERSION, Perl $], $^X" );

done_testing();
