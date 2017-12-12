<?php
function equivalenceClass($representative, $graph){
  $expanded = [];
  $to_expand = [$representative];
  while(!empty($to_expand)){
    $current = array_pop($to_expand);
    array_push($expanded, $current);
    $transitive = $graph[$current];
    foreach ((array)$transitive as $candidate) {
      if(!in_array($candidate, $expanded) && !in_array($candidate, $to_expand)){
        array_push($to_expand, $candidate);
      }
    }
  }
  return $expanded;
}
$handle = fopen("/Users/mariosangiorgio/Downloads/input", "r");
if ($handle) {
    $graph = [];
    while (($line = fgets($handle)) !== false) {
      $line = trim($line);
      $tokens = explode(" <-> ", $line);
      $graph[$tokens[0]] = explode(", ", $tokens[1]);
    }
    fclose($handle);
    // Part 1
    $expanded = equivalenceClass(0, $graph);
    printf("%d\n", sizeof($expanded));
    $equivalence_classes = 0;
    $nodes = array_keys($graph);
    while(!empty($nodes)){
      $representative = array_pop($nodes);
      $group = equivalenceClass($representative, $graph);
      $nodes = array_diff($nodes,$group);
      $equivalence_classes++;
    }
    echo $equivalence_classes;
} else {
  echo "Cannot open the input file";
}
?>