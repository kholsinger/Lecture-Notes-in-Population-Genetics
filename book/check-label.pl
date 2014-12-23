#!/usr/bin/perl -w

use strict;

my $infile = 'book.aux';
my %labels = ();

open(INFILE, "<$infile")
  or die "Could not open $infile for input: $!";
while (<INFILE>) {
  next unless m/^\\newlabel/;
  chomp;
  my $line = $_;
  $line =~ s/^\\newlabel\{(.*?)\}.*$/$1/g;
  $labels{$line} += 1;
}
close(INFILE);

foreach my $label (sort bycount keys %labels) {
  print "$label: $labels{$label}\n";
}

sub bycount {
  $labels{$b} <=> $labels{$a};
}
