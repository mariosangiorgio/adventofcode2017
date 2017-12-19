#include<iostream>
#include<fstream>
#include<vector>
#include<algorithm>

uint8_t entry_column(std::string const& top_row){
  uint8_t i = 0;
  while(top_row[i] != '|'){
    ++i;
  }
  return i;
}

int main(){
  std::vector<std::string> lines;
  std::string line;
  std::ifstream f ("/Users/mariosangiorgio/Downloads/input");
  getline(f, line);
  uint8_t row=0;
  uint8_t column=entry_column(line);
  while(getline(f, line)) {
    lines.push_back(std::string(line));
  }
  int8_t d_row=1;
  int8_t d_column=0;
  char c;
  while((c = lines[row][column]) != ' '){
    if(c == '+'){
      if(d_row == 1 || d_row == -1){
        d_row = 0;
        if(lines[row][column + 1] != ' '){
          d_column = 1;
        }
        else if(lines[row][column - 1] != ' '){
          d_column = -1;
        }
      }
      else{
        d_column = 0;
        if(lines[row + 1][column] != ' '){
          d_row = 1;
        }
        else if(lines[row  -1][column] != ' '){
          d_row = -1;
        }
      }
    }
    if(c >= 'A' && c <= 'Z'){
      std::cout << c;
    }
    row += d_row;
    column += d_column;
  }
}