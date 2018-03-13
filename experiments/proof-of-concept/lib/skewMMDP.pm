use strict;
use warnings;

use v5.14; # For say

=head1 NAME

skewMMDP - Massively Multimodal Deceptive Problem with skewed uncertainty

=head1 SYNOPSIS

    use skewMMDP;

    my @chromosome = "010101101010111111000000"

    my $fitness_object = skewMMDP->new()
    $fitness = $fitness_object->apply( $chromosome)

#and again

    $fitness = $fitness_object->apply( $chromosome)


=head1 DESCRIPTION

Massively Multimodal Deceptive Problem, tough for evolutionary algorithms.

=head1 METHODS

=cut

package skewMMDP;

our $VERSION = '0.1';


our @unitation = qw( 1 0 0.360384 0.640576 0.360384 0 1);

use constant BLOCK_SIZE => 6;

=head2 new()

Initializes the cache

=cut 

sub new {
  my $class = shift;
  my $skewness = shift || 1;
  my $self = { _skewness => $skewness,
	       _sigma => $skewness / sqrt(1 + $skewness ** 2),
	       _generator => rand_nd_generator(0,0.1)};
  bless $self, $class;
  return $self;
}

=head2 apply( $string )

Computes the MMDP value for a binary string, storing it in a cache.

=cut 

sub apply {
  my $self = shift;
  my $string = shift;
  my $fitness = 0;
  for ( my $i = 0; $i < length($string); $i+= BLOCK_SIZE ) {
    my $block = substr( $string, $i, BLOCK_SIZE );
    my $ones = grep ( /1/, split(//,$block));
    $fitness += $unitation[$ones]+$self->generate_sn();
  }
  return $fitness;
}


sub generate_sn {
  my $self = shift;
  my $skewness = $self->{'_skewness'};
  my $a = $self->{'_generator'}();
  my $b = $self->{'_generator'}();
  my $sconst = $self->{'_sigma'};
  my $c = $sconst * $a + sqrt(1 - $sconst ** 2) * $b;
#  say "$a, $c";
  return $a > 0 ? $c : -$c ;
}

use constant TWOPI => 2.0 * 4.0 * atan2(1.0, 1.0);

sub rand_nd_generator(;@)
{
    my ($mean, $stddev) = @_;
    $mean = 0.0 if ! defined $mean;
    $stddev = 1.0 if ! defined $stddev;

    return sub {
        return $mean + $stddev * cos(TWOPI * (1.0 - rand)) * sqrt(-2.0 * log(1.0 - rand));
    }
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  generate_sn by Jiří Václavík https://metacpan.org/pod/Math::Random::SkewNormal
rand_nd_generator by Oleg Alistratov  https://github.com/alistratov/math-random-normaldistribution/blob/master/lib/Math/Random/NormalDistribution.pm

=cut

"What???";
