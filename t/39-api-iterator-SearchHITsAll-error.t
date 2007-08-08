#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 1;
BEGIN { push(@INC, "lib", "t"); }
use TestHelper;

my $mturk = TestHelper->new;
my $result = $mturk->expectError("AWS.ParameterOutOfRange", sub {
    my $hits = $mturk->SearchHITsAll( PageSize => 101 );
    $hits->next;
});

ok($result, "Expected error in SearchHITsAll");
