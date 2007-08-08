#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;
BEGIN { push(@INC, "lib", "t"); }
use TestHelper;

my $mturk = TestHelper->new;
ok( $mturk, "Created client");

my $balance = $mturk->getAvailableBalance();
ok($balance =~ /^\d+\.\d+$/, "GetAccountBalance");
