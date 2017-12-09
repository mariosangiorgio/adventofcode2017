#include <stdio.h>
#define BUFFER_SIZE 1024

typedef enum { Content,
               Garbage,
               Ignore } State;

int main(int argc, char *argv[])
{
  FILE *f = fopen("/Users/mariosangiorgio/Downloads/input", "r");
  if(f == NULL){
    printf("Cannot read file");
    return 1;
  }
  char buffer[BUFFER_SIZE];
  int chars_read;

  int total_score = 0;
  int depth = 0;
  State state = Content;
  while((chars_read = fread(buffer, sizeof(*buffer), sizeof(buffer)/sizeof(*buffer), f)))
  {
    int i = 0;
    while (i < chars_read)
    {
      if(buffer[i] == '\n'){
        state = Content;
      }
      switch (state)
      {
      case Content:
        switch (buffer[i])
        {
        case '{':
          depth++;
          total_score += depth;
          break;
        case '}':
          depth--;
          break;
        case '<':
          state = Garbage;
          break;
        }
        break;
      case Ignore:
        // Ignores the current value.
        // The next value will still be garbage
        state = Garbage;
        break;
      case Garbage:
        switch (buffer[i])
        {
        case '!':
          state = Ignore;
          break;
        case '>':
          state = Content;
          break;
        }
        break;
      }
      i++;
    }
  }
  fclose(f);
  printf("Total score: %d\n", total_score);
  return 0;
}