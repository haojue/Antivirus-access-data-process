#!/usr/bin/perl -w
use Data::Dumper;

open (FILE, "$ARGV[0]") or die "Can't open myfile: $!";
my %hash=();
while ($line = <FILE>) {
chomp($line);
if(exists$hash{"$line"})
{
$hash{"$line"}++;
}
else {
$hash{"$line"} = 1;
}
}
open(FH, "> $ARGV[1]") || die "can't open $! \n" ;

foreach$key(sort keys %hash)
{
     print FH "$key     $hash{$key}\n";
}
close(FILE);
close(FH) ;
