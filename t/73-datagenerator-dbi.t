#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
BEGIN { push(@INC, "lib", "t"); }
use Net::Amazon::MechanicalTurk::RowData;
use Net::Amazon::MechanicalTurk::RowData::SQLRowData;

eval {
    require DBI;
    require DBD::SQLite; 
};
if ($@) {
    plan skip_all => "SQLite not installed.";
}
else {
    plan tests => 2; 
}

# Generate some data
#-----------------------
my $dbfile = "t/data/test.db";
unlink($dbfile) if (-f $dbfile);
my $dbh = DBI->connect("dbi:SQLite:dbname=${dbfile}","","", {
    RaiseError => 1,
    AutoCommit => 1
});

$dbh->do(qq{
    CREATE TABLE MTURK_TEST (
        ID INTEGER,
        DATA DOUBLE,
        TIME VARCHAR(20)
    );
});

my $sth = $dbh->prepare(qq{
    INSERT INTO MTURK_TEST VALUES(?,?,?)
});

# Insert some rows
foreach my $id (1..30) {
    $sth->execute($id, rand(), scalar localtime());
}
$sth->finish();

# Actual test
#----------------------
my $data = Net::Amazon::MechanicalTurk::RowData::SQLRowData->new(
    dbh    => $dbh,
    sql    => "SELECT * FROM MTURK_TEST WHERE ID BETWEEN ? AND ?",
    params => [10, 19]
);

my $count = 0;
$data->each(sub {
    my ($_data, $row) = @_;
    fail unless exists $row->{ID};
    fail unless exists $row->{DATA};
    fail unless exists $row->{TIME};
    fail unless $data->fieldNames->[0] eq 'ID';
    fail unless $data->fieldNames->[1] eq 'DATA';
    fail unless $data->fieldNames->[2] eq 'TIME';
    $count++;
});

ok($count == 10, "SQLRowData w/ query params");

$data = Net::Amazon::MechanicalTurk::RowData::SQLRowData->new(
    dbh => $dbh,
    sql => "SELECT * FROM MTURK_TEST"
);

$count = 0;
$data->each(sub {
    my ($_data, $row) = @_;
    fail unless exists $row->{ID};
    fail unless exists $row->{DATA};
    fail unless exists $row->{TIME};
    fail unless $data->fieldNames->[0] eq 'ID';
    fail unless $data->fieldNames->[1] eq 'DATA';
    fail unless $data->fieldNames->[2] eq 'TIME';
    $count++;
});

ok($count == 30, "SQLRowData");


$dbh->disconnect;
