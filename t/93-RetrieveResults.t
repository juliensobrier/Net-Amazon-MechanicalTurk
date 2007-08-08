#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 4;
BEGIN { push(@INC, "lib", "t"); }
use TestHelper;

my $mturk = TestHelper->new;
ok( $mturk, "Created client");


my $reviewable = $mturk->GetReviewableHITs();
ok( $reviewable, "Got Reviewable HITs");
ok( (@{$reviewable->{HIT}}), "Actual reviewable hits" );

my @hits;
foreach my $hit (@{$reviewable->{HIT}}) {
    push(@hits, { HITId => $hit->{HITId}[0] });
}

my @output; 

$mturk->retrieveResults(
    input    => \@hits, 
    output   => sub { 
        my ($row) = @_;
        push(@output, $row);
    },
    progress => \*STDOUT
);

printf "RetrieveResults returned %d results.\n", scalar @output;

ok( 1, "RetrieveResults");
