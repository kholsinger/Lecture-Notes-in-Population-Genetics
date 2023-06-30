#!/usr/bin/perl

## Usage: latex2html.pl <filename>
##
## assumes .tex extension on LaTeX filename
##
## Author: Kent Holsinger
## Date:   2 August 2020
##

use strict;

use File::Temp qw/:POSIX/;
use File::Copy;

my $latex_file = shift or die error();

my $tmp_fh;
my $tmp_file;
($tmp_fh, $tmp_file) = tmpnam(DIR => ".");

my $html_file = $latex_file;
$html_file =~ s/^(.*)\.tex$/$1.html/;

my $pandoc_file = $latex_file;
$pandoc_file =~ s/^(.*)\.tex$/$1-pandoc.tex/;

my @png_files = ();

open(my $fh, "<", $latex_file) or
  die "Can't open $latex_file: $!";
open($tmp_fh, ">", $tmp_file) or
  die "Can't open $tmp_file: $!";
while (my $line = <$fh>) {
  chomp($line);
  if ($line =~ m/includegraphics/) {
    if ($line =~ m/resizebox/) {
      $line =~ s/^.*resizebox.*(\\includegraphics.*\{.*\.eps\}).*$/$1/;
    }
    my $eps_file = $line;
    $eps_file =~ s/^.*\{(.*)\.eps\}/$1.eps/;
    my $png_file = $line;
    $png_file =~ s/^.*\{(.*)\.eps\}/$1.png/;
    my @args = ("magick", "convert", $eps_file, $png_file);
    system(@args) == 0 or
      die "system @args failed: $?";
    $line =~ s/$eps_file/$png_file/;
    push(@png_files, $png_file);
  }
  print $tmp_fh $line, "\n";
}
close($tmp_fh);
close($fh);

move($tmp_file, $pandoc_file);

my @args = ("pandoc", "--standalone", "--mathjax", "--table-of-contents",
           "--css=pandoc.css", "-o", $html_file, $pandoc_file);
system(@args) == 0 or
  die "system @args failed: $?";

unlink($pandoc_file) or
  die "Could not delete $pandoc_file: $!";

move($html_file, "HTML/$html_file");
foreach my $png_file (@png_files) {
  move($png_file, "HTML/$png_file");
}

sub error {
  die "latex2html.pl <filename>";
}

