#!/usr/bin/perl -w
use Data::Dumper;
use threads;
#open (FILE, "$ARGV[0]") or die "Can't open myfile: $!";
#system `echo > xxxdomain.stats`;
system `echo > "$ARGV[1]"`;
print "ARGv0 $ARGV[0] ARGV1 $ARGV[1] ARGV2 $ARGV[2] \n";                                                                                                                                             
my $i;
my @threads;
for($i=0;$i<$ARGV[2];$i++){  
my $tmp = threads->create('dns_query', $ARGV[0]._.$i);
print "thread $tmp\n";
push @threads, $tmp;
}

sub dns_query 
{
my $file=shift;
open (FILE, "$file") or die "Can't open myfile: $!";
open(FH, ">> $ARGV[1]") or die "can't open $! \n" ;
my $blank = <FILE> if($file =~ /occur_0/);
while ($tmp = <FILE>) {
chomp($tmp);
my ($line, $freq) = split /\s+/,$tmp;
my $result = `nslookup $line`;
print "$file $line";
     if ( "$result" =~ /\d+\.\d+\.\d+\.\d+\.in-addr\.arpa\s+name = (.*)/) {
     $match = $1;
     print ("\nmatch is $match\n");
     print FH "$line $match $freq\n";
    } else {
     print ("\nno match\n"); 
     print FH "$line N/A $freq\n";
  } 
}
close(FILE);
}
for($i=0;$i<$ARGV[2];$i++){ 
$threads[$i]->join;
}
close(FH);
