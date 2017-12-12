<?php
$handle = fopen("/Users/mariosangiorgio/Downloads/input", "r");
if ($handle) {
    $graph = [];
    while (($line = fgets($handle)) !== false) {
      $line = trim($line);
      $tokens = explode(" <-> ", $line);
      $graph[$tokens[0]] = explode(", ", $tokens[1]);
    }
    fclose($handle);
    // Compute the transitive closure
    $expanded = [];
    $to_expand = [0];
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
    echo sizeof($expanded);
} else {
  echo "Cannot open the input file";
}
?>