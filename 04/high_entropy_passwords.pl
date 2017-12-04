use strict;
use warnings;
use List::MoreUtils qw(uniq);

open my $handle, '<', "/Users/mariosangiorgio/Downloads/input";
chomp(my @lines = <$handle>);
my $valid = 0;
foreach my $line (@lines){
  my @words = split / /, $line;
  if((scalar @words) == (scalar uniq @words)){
    $valid++;
  }
}
print $valid;
close $handle;