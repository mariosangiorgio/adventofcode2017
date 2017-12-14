#! /bin/bash
set -euo pipefail
echo "Part 1"
cat input | awk -F ": " '{if(($1 % ($2*2-2)) == 0) s+=$1*$2} END {print s}'

echo "Part 2"
cat input | awk -F ": " -f part2.awk