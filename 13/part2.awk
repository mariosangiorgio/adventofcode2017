BEGIN{
  i=0
}
{
  distance[i] = $1
  depth[i]=$2
  i=i+1
}
END {
  delay=0
  found=0
  while(!found){
    found=1
    for (j=0; j<i; j++){
      if((distance[j]+delay)%(2*depth[j]-2) == 0){
        found=0;
        break;
      }
    }
    delay++;
  }
  print delay-1
}