function main() {
  var i=10;
  var y=0;
  for(var i=1; i<=2; ++i) {
    if(y==0){
      y=1;
      //continue;
      break;
    }
    y=y+2;
  }
  print(y, "\n"); // should be 10
}
