use strict; #-*-cperl-*-
use warnings;

=head1 NAME

Algorithm::Evolutionary::Individual::NoisyBitString - BitString with noise parameters added


=head1 SYNOPSIS

    use Algorithm::Evolutionary::Individual::NoisyBitString;

    # Length 10, random bitstring, skewness equal to 1, signa 0.1
    my $indi = new Algorithm::Evolutionary::Individual::NoisyBitString 10 ; # Build random bitstring with length 10

=head1 Base Class

L<Algorithm::Evolutionary::Individual::BitString>

=head1 DESCRIPTION

Noisy Bitstring Individual for a Genetic Algorithm. Used in evolution with uncertainty

=cut

package Algorithm::Evolutionary::Individual::NoisyBitString;

use lib qw( /home/jmerelo/proyectos/CPAN/Algorithm-Evolutionary/lib );
use Carp;

our $VERSION =  '0.0.1';

use base 'Algorithm::Evolutionary::Individual::BitString';

use Algorithm::Evolutionary::Fitness::Skewed;

use constant MY_OPERATORS => ( Algorithm::Evolutionary::Individual::String::MY_OPERATORS, 
			       qw(Algorithm::Evolutionary::Op::BitFlip Algorithm::Evolutionary::Op::Mutation )); 

use Algorithm::Evolutionary::Utils qw(decode_string); 

=head1 METHODS

=head2 new( $length, $skewness = 1, $normal_sigma = 0 )

Creates a new random bitstring individual, with fixed initial length, and 
uniform distribution of bits. Options as in L<Algorithm::Evolutionary::Individual::String>

=cut

sub new {
  my $class = shift;
  my $fitness_function = shift;
  my $self = 
    Algorithm::Evolutionary::Individual::BitString::new( 'Algorithm::Evolutionary::Individual::BitString' );


  $self->{'_skewness'} = shift || 1;
  $self->{'_normal_sigma'} = shift || 0.1;
  $self->{'_skewed_fitness'} = new Algorithm::Evolutionary::Fitness::Skewed( $fitness_function, $self->{'_skewness'}, $self->{'_normal_sigma'} ); 
  return $self;
}

=head2 evaluate( )

Evaluates itself. Overrides C<evaluate> in base, which needs a fitness function or object

=cut

sub evaluate {
  my $self = shift;
  my $fitness_func = $self->{'_skewed_fitness'};
  return $self->Fitness( $fitness_func->($self) );

}

=head2 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

=cut
