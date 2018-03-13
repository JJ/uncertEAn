#!/usr/bin/env perl

#Test the MMDP fitness function

use warnings;
use strict;

use lib qw( ../../../CPAN/Algorithm-Evolutionary/lib lib ); #Just in case we are testing it in-place

use Algorithm::Evolutionary::Fitness::MMDP;
use Algorithm::Evolutionary::Individual::String;
use Algorithm::Evolutionary::Fitness::Skewed;

use v5.14;

my $units = "000000";
my $mmdp = new  Algorithm::Evolutionary::Fitness::MMDP;
my $noisy = new Algorithm::Evolutionary::Fitness::Skewed( $mmdp );
for (my $i = 0; $i < length($units); $i++ ) {
    my $clone = $units;
    substr($clone, $i, 1 ) = "1";
    my $this_chromosome = Algorithm::Evolutionary::Individual::String->fromString( $clone );
    for (my $j = 0; $j < 100; $j++ ) {
      print  $noisy->apply( $this_chromosome ), ",";
    }
    print "\n";
    $units = $clone;
}


