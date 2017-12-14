import java.io.*;

public class DiskDefragmentation{
  public static void main(String[] args){
        String fileName = "input";
        try {
            byte[] buffer = new byte[1000];
            FileInputStream inputStream = new FileInputStream(fileName);
            int total = 0;
            int nRead = 0;
            while((nRead = inputStream.read(buffer)) != -1) {
                for(int i=0; i<nRead; ++i){
                  int n = 0;
                  if(buffer[i] >= 'a' && buffer[i] <= 'z'){
                    n = buffer[i] - 'a' + 10;
                  }
                  if(buffer[i] >= '0' && buffer[i] <= '9'){
                    n = buffer[i] - '0';
                  }
                  int bits = Integer.bitCount(n);
                  total += bits;
//                  System.out.println(((char)buffer[i]) + " " + n + " " + bits);
                }
            }
            inputStream.close();
            System.out.println(total);
        }
        catch(FileNotFoundException ex) {
            System.out.println("Unable to open file '" + fileName + "'");
        }
        catch(IOException ex) {
            System.out.println("Error reading file '" + fileName + "'");
        }
  }
}