#! /bin/bash
set -euo pipefail
echo "Part 1"
cat input | awk -F ": " '{if(($1 % ($2*2-2)) == 0) s+=$1*$2} END {print s}'

echo "Part 2"
# This works but it is extremely slow.
C=0
CAUGHT=1
while [ $CAUGHT -gt 0 ]; do
  # Counts the number of times we've got caught.
  # Getting caught at the first step has cost 0, but is still an issue
  CAUGHT=$(cat input | awk -v c=$C -v r=0 -F ": " '{if((($1+c) % ($2*2-2)) == 0) {r=1;exit}} END {print r}')
  let C=C+1
done
echo $(($C-1))
