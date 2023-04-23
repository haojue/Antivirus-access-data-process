#!/usr/bin/perl -w
#################################################
# Copyright 2017-2023 HaojueWang <acewhj@gmail.com>
# All Rights Reserved.
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#################################################
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
