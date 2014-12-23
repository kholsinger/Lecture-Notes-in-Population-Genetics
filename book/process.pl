#!/usr/bin/perl -w

use strict;

use constant FALSE => 0;
use constant TRUE => 1;

my $baseName = shift
  or die "Must specify basename on command line";

open(INFILE, "<../$baseName")
  or die "Could not open ../$baseName for input: $!";
open(OUTFILE, ">$baseName")
  or die "Could not open $baseName for output: $!";
while (<INFILE>) {
  next unless m/\\title/;
  my $line = $_;
  $line =~ s/^.*\\title(\{.*\}).*$/\\chapter$1/;
  print OUTFILE $line;
  last;
}
while (<INFILE>) {
  next unless m/\\section/;
  last;
}
while (<INFILE>) {
  last if m/\\bibliography/;
  last if m/\\ccLicense/;
  print OUTFILE;
}
close(OUTFILE);
close(INFILE);
