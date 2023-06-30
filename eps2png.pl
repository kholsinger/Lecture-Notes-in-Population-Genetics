#!/usr/local/bin/perl

use strict;

my $eps_file = shift or die error();
my $png_file = $eps_file;
$png_file = s/^(*+)\.eps$/$1.png/;
print $png_file;

sub error {
  die "eps2png.pl <filename>";
}
