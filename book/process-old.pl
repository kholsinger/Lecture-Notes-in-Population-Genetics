#!/usr/bin/perl -w

use strict;

use constant FALSE => 0;
use constant TRUE => 1;

my $baseName = shift
  or die "Must specify basename on command line";

open (INFILE, "<../not-maintained/$baseName")
    or die "Could not open ../not-maintained/$baseName for input: $!";
open(OUTFILE, ">$baseName")
  or die "Could not open $baseName for output: $!";
while (my $line = <INFILE>) {
  next unless $line =~ m/\\title/;
  $line =~ s/^.*\\title(\{.*\}).*$/\\chapter$1/;
  print OUTFILE $line;
  last;
}
while (my $line = <INFILE>) {
  next unless $line =~ m/\\section/;
  last;
}
while (my $line = <INFILE>) {
  last if $line =~ m/\\bibliography/;
  last if $line =~ m/\\ccLicense/;
  print OUTFILE $line;
}
close(OUTFILE);
close(INFILE);
