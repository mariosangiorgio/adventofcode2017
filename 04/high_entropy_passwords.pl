use strict;
use warnings;
use feature qw(say);
use List::MoreUtils qw(uniq);

open my $handle, '<', "/Users/mariosangiorgio/Downloads/input";
chomp(my @lines = <$handle>);
my $valid1 = 0;
my $valid2 = 0;
foreach my $line (@lines){
  my @words = split / /, $line;
  my $n = scalar @words;
  if($n == (scalar uniq @words)){
    $valid1++;
  }
  my @canonical_words = map {join '', sort split //, $_ } @words;
  if($n == (scalar uniq @canonical_words)){
    $valid2++;
  }
}
say $valid1;
say $valid2;
close $handle;