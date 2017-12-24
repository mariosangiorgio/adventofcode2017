def strongest(to_assign, pins_to_match, strength):
    def matches(segment):
        a,b = segment
        return a == pins_to_match or b == pins_to_match
    compatible_segments = [s for s in to_assign if matches(s)]
    if(len(compatible_segments) == 0):
        return strength
    def next(segment):
        a,b = segment
        left_to_assign = [s for s in to_assign if s != segment]
        next_pin = a if a != pins_to_match else b
        return strongest(left_to_assign, next_pin, strength + a + b)
    return max(map(next, compatible_segments))

def parse(line):
    tokens = line.split("/")
    return (int(tokens[0]), int(tokens[1]))

with open("input.txt") as f:    
    input = list(map(parse, f.readlines()))
    print(strongest(input, 0, 0))