#!/usr/bin/env perl

=head1 NAME

  PoC - Proof of concept for new uncertain evolutionary algorithms

=head1 SYNOPSIS

[ TODO ]
  

=head1 DESCRIPTION  

A simple example of how to run an Evolutionary algorithm based on
Algorithm::Evolutionary. Optimizes a noisy Trap, with skewed noise

=cut

use warnings;
use strict;
use v5.14;

use Time::HiRes qw( gettimeofday tv_interval);
use YAML qw(LoadFile);
use IO::YAML;
use DateTime;
use Config;

use lib qw(lib ../lib /home/jmerelo/Code/CPAN/Algorithm-Evolutionary/lib); # Local paths

use Algorithm::Evolutionary::Individual::BitString;
use Algorithm::Evolutionary::Op::Tournament_Selection;
use Algorithm::Evolutionary::Op::Replace_Worst;
use Algorithm::Evolutionary::Op::Generation_Skeleton_Ref;
use Algorithm::Evolutionary::Op::Mutation;
use Algorithm::Evolutionary::Op::Crossover;
use Algorithm::Evolutionary::Fitness::Trap;
use Algorithm::Evolutionary::Fitness::SkewTrap;

use Math::Random qw(random_normal);

#----------------------------------------------------------#
my $conf_file = shift || die "Usage: $0 <yaml-conf-file.yaml>\n";

my $conf = LoadFile( $conf_file ) || die "Can't open configuration file $conf_file\n";


#----------------------------------------------------------#
my $chromosome_length = $conf->{'chromosome_length'} || die "Chrom length must be explicit";
my $best_fitness = $conf->{'best_fitness'} || die "Need to know the best fitness";
my $population_size = $conf->{'population_size'} || 1024; #Population size
my $max_evals = $conf->{'max_evals'}  || 100000; #Max number of generations
my $replacement_rate = $conf->{'replacement_rate'} || 0.5;
my $tournament_size =  $conf->{'tournament_size'}|| 2;
my $mutation_priority = $conf->{'mutation_priority'} || 1;
my $crossover_priority =  $conf->{'crossover_priority'}|| 4;
my $noise_sigma = $conf->{'noise_sigma'}|| 1;
my $number_of_bits =  $conf->{'number_of_bits'}|| 4;

# Open output stream
#----------------------------
my $ID="res-unc-poc-p". $population_size."-ns". $noise_sigma."-cs".$chromosome_length."-rr".$replacement_rate;
my $io = IO::YAML->new("$ID-".DateTime->now().".yaml", ">");
$conf->{'uname'} = $Config{'myuname'}; # conf stuff
$conf->{'arch'} = $Config{'myarchname'};
$io->print( $conf );

#----------------------------------------------------------#
#Initial population
my @pop;
#Creating $population_size guys
for ( 0..$population_size ) {
  my $indi = Algorithm::Evolutionary::Individual::BitString->new( $chromosome_length );
  push( @pop, $indi );
}

#----------------------------------------------------------#
# Variation operators
my $m = Algorithm::Evolutionary::Op::Mutation->new( 0.1, $mutation_priority );
my $c = Algorithm::Evolutionary::Op::Crossover->new(2, $crossover_priority);

#----------------------------------------------------------#
# Fitness functions, noisy and not
my $fitness_object = new  Algorithm::Evolutionary::Fitness::Trap( $number_of_bits); #for evaluation
my $noisy = new  Algorithm::Evolutionary::Fitness::SkewTrap( $number_of_bits);

#----------------------------------------------------------#
# Usamos estos operadores para definir una generación del algoritmo. Lo cual
# no es realmente necesario ya que este algoritmo define ambos operadores por
# defecto. Los parámetros son la función de fitness, la tasa de selección y los
# operadores de variación.
#my $fitness = sub { $trap->apply(@_) };

my $selector = new  Algorithm::Evolutionary::Op::Tournament_Selection $tournament_size;
my $replacer = new  Algorithm::Evolutionary::Op::Replace_Worst;

my $generation = Algorithm::Evolutionary::Op::Generation_Skeleton_Ref->new( $noisy, $selector, [$m, $c], $replacement_rate , $replacer ) ;

#Time
my $inicioTiempo = [gettimeofday()];

#----------------------------------------------------------#

do {
  for ( @pop ) { # Reevaluate always before applying genetic operators
    $_->evaluate( $noisy );
  }
  $generation->apply( \@pop );
  $io->print( { evals => $noisy->evaluations(),
		best => $pop[0] } );
} while( ($noisy->evaluations() < $max_evals) 
	 && ($fitness_object->apply($pop[0]) < $best_fitness)); # Use non-noisy fitness for end.

#----------------------------------------------------------#
#leemos el mejor resultado

#Mostramos los resultados obtenidos
$io->print( { end => { best => $pop[0],
		     time =>tv_interval( $inicioTiempo ) , 
		     evaluations => $noisy->evaluations()}} );

=head1 AUTHOR

Contributed by Pedro Castillo Valdivieso, modified by J. J. Merelo

=cut

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

=cut
