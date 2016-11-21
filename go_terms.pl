#!/usr/bin/env perl
# ** FETCHING GRAPH OBJECTS FROM AN ONTOLOGY FILE **

use strict;
use warnings;
use GO::Parser;

print STDERR "INIT\n";

# Input filenames
my $go_list_filename;
my $obo_file;

$go_list_filename = $ARGV[0];
$obo_file = $ARGV[1];

# go_perl
my $parser = new GO::Parser({handler=>'obj'}); # creates parser object

print STDERR "Parsing OBO file...\n";
$parser->parse($obo_file); # parse OBO GO file
my $graph = $parser->handler->graph; # GO::Model::Graph

my ($curracc, $term, $name, $definition);

# TEST
#$curracc = "GO:0000015";
#$term = $graph->get_term($curracc);
#$name = $term->name;
#$definition = $term->definition;
#printf STDERR "TEST: %s\t%s\t%s\n", $curracc, $name, $definition;

# Look for data of terms in input file
print STDERR "Looking for terms in: " . $go_list_filename . "\n";
open my $data, $go_list_filename or die "Could not open $go_list_filename: $!";

while (my $line = <$data>) {
    #print STDERR $curracc;
    #($curracc = $line) =~ s/^\s+|\s+$//g;
    chomp $line;
    $curracc = $line;
    $term = $graph->get_term($curracc); # find_term(acc=>$curracc);
    if (defined $term) {
        $name = $term->name;
        $definition = $term->definition;
        printf "%s\t%s\t%s\n", $curracc, $name, $definition;
    } else {
        print STDERR "*** Term not found ".$curracc."\n";
        printf "%s\t%s\t%s\n", $curracc, "NF", "NF";
    }
}

print STDERR "END\n";

## END