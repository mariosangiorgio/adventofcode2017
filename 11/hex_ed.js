fs = require('fs');
var input = fs.readFileSync('/Users/mariosangiorgio/Downloads/input', 'utf8');
// See https://www.redblobgames.com/grids/hexagons/#coordinates
var x=0,y=0,z=0;
var furthest = 0;
function distance(x1,y1,z1, x2,y2,z2){
  return (Math.abs(x1-x2) + Math.abs(y1 - y2) + Math.abs(z1 - z2)) / 2;
}
input.trim().split(',').forEach(element => {
  switch(element){
    case 'n':       y++; z--; break;
    case 'ne': x++;      z--; break;
    case 'se': x++; y--;      break;
    case 's':       y--; z++; break;
    case 'sw': x--;      z++; break;
    case 'nw': x--; y++;      break;
    default: throw new Error('Invalid input' + element);
  }
  furthest = Math.max(furthest, distance(x,y,z, 0,0,0));
});
console.log(x,y,z);
console.log(distance(x,y,z, 0,0,0));
console.log(furthest);