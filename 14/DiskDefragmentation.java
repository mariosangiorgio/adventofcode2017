import java.io.*;

public class DiskDefragmentation{
  private static boolean fill(int x, int y, int[][] map, int value){
      if(x >= 0 && x < 128 && y >= 0 && y < 128 && map[x][y] == 1){
          map[x][y] = value;
          fill(x+1,y,map,value);
          fill(x-1,y,map,value);
          fill(x,y+1,map,value);
          fill(x,y-1,map,value);
          return true;
      }
      return false;
  }
  public static void main(String[] args){
        String fileName = "input";
        int[][] map = new int[128][128];
        try {
            byte[] buffer = new byte[1000];
            FileInputStream inputStream = new FileInputStream(fileName);
            int total = 0;
            int nRead = 0;
            int x = 0, y = 0;
            while((nRead = inputStream.read(buffer)) != -1) {
                for(int i=0; i<nRead; ++i){
                  if(buffer[i] == '\n'){
                      x = 0;
                      y++;
                  }
                  else{
                    int n = Integer.parseInt(String.valueOf((char) buffer[i]), 16);
                    total += Integer.bitCount(n);
                    map[x++][y] = (n & 8) >> 3;
                    map[x++][y] = (n & 4) >> 2;
                    map[x++][y] = (n & 2) >> 1;
                    map[x++][y] = (n & 1) >> 0;
                  }
                }
            }
            // 0 empty
            // 1 to assign
            int value = 2;
            for(y=0;y<128;++y){
                for(x=0;x<128;++x){
                    if(fill(x,y,map,value)){
                        value++;
                    }
                }
            }
            inputStream.close();
            System.out.println("Part 1: " + total);
            System.out.println("Part 2: " + (value - 2));
        }
        catch(FileNotFoundException ex) {
            System.out.println("Unable to open file '" + fileName + "'");
        }
        catch(IOException ex) {
            System.out.println("Error reading file '" + fileName + "'");
        }
  }
}