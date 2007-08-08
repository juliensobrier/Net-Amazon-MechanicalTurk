#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 3;
BEGIN { push(@INC, "lib", "t"); }
use TestHelper;

my $mturk = TestHelper->new;
ok( $mturk, "Created client");

my $url = $mturk->getHITTypeURL( "fakeHITTypeID" );
ok($url =~ /fakeHITTypeID/, "GetHITTypeURL contains HITTypeID");
ok($url =~ /mturk\/preview\?/, "GetHITTypeURL looks nice");

# TODO -- should create a real hit, generate the url, then ensure we can access that url
