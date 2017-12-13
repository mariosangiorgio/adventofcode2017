def parse(line):
  tokens = map(int,line.strip().split(": "))
  return (tokens[0], tokens[1])

def check(delay, input):
  for (n,d) in input:
    if (n + delay) % (2*d-2) == 0:
      return False
  return True

file = open("input", "r")
input = map(parse, file.readlines())
file.close()

# Solution to part two only. Same logic than awk, but faster
delay = 0
while not check(delay, input):
  delay = delay + 1
print delay