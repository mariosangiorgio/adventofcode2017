import java.io.*;

public class DiskDefragmentation{
  private static int bits(byte value){
    int n = Integer.parseInt(String.valueOf((char) value), 16);
    return Integer.bitCount(n);
  }
  public static void main(String[] args){
        String fileName = "input";
        try {
            byte[] buffer = new byte[1000];
            FileInputStream inputStream = new FileInputStream(fileName);
            int total = 0;
            int nRead = 0;
            while((nRead = inputStream.read(buffer)) != -1) {
                for(int i=0; i<nRead; ++i){
                  total += bits(buffer[i]);
                }
            }
            inputStream.close();
            System.out.println("Part 1: " + total);
        }
        catch(FileNotFoundException ex) {
            System.out.println("Unable to open file '" + fileName + "'");
        }
        catch(IOException ex) {
            System.out.println("Error reading file '" + fileName + "'");
        }
  }
}