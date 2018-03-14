use strict;
use warnings;

=head1 NAME

Algorithm::Evolutionary::Op::MutationWithNoise - Mutates also "noisy" components of individual

=head1 SYNOPSIS

  use Algorithm::Evolutionary::Op::MutationWithNoise;

  #Create from scratch
  my $op = new Algorithm::Evolutionary::Op::MutationWithNoise; 

  #All options
  my $mutation = new Algorithm::Evolutionary::Op::MutationWithNoise 0,1;

=head1 Base Class

L<Algorithm::Evolutionary::Op::Base|Algorithm::Evolutionary::Op::Base>

=head1 DESCRIPTION

Mutation operator for a GA

=cut

package Algorithm::Evolutionary::Op::MutationWithNoise;

our $VERSION = "0.0.1";

use lib qw( /home/jmerelo/proyectos/CPAN/Algorithm-Evolutionary/lib );
use Carp;

use Math::Random qw(random_normal);

use Algorithm::Evolutionary::Op::Bitflip;
use base 'Algorithm::Evolutionary::Op::Bitflip';

#Class-wide constants
our $APPLIESTO =  'Algorithm::Evolutionary::Individual::NoisyBitString';
our $ARITY = 1;

=head1 METHODS

=head2 new( [$sd = 0.1] [, $operator_probability] )

Multiplicative mutation with standard deviation equal to 0.1 by default

=cut

sub new {
  my $class = shift;
  my $sd = shift || 0.1; 
  my $rate = shift || 1;

  my $self = new Algorithm::Evolutionary::Op::Bitflip( $rate );
  bless $self, $class;
  $self->{'_rng'} = sub { return random_normal( 1, 1, $sd ) };
  return $self;
}


=head2 apply( $chromosome )

Applies normal mutation to the bitstring chromosome, and gaussian multiplicative mutation to the two rates.

=cut

sub apply ($;$) {
  my $self = shift;
  my $arg = shift || croak "No mutie here!";
  my $mutie = $self->SUPER::apply( $arg );
  $mutie->{'_skewness'} *= $self->{'_rng'};
  $mutie->{'_normal_sigma'} *= $self->{'_rng'};
  return $mutie;
}

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

=cut

