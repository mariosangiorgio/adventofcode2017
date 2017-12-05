local function read_file(path)
    local lines = {}
    for line in io.lines(path) do
      lines[#lines + 1] = tonumber(line) -- index starts at 1
    end
    return lines
end

local function interpret(memory, editor)
  local program_counter = 1
  local steps = 0
  while(program_counter <= #memory)do
    local jump = memory[program_counter]
    memory[program_counter] = editor(jump)
    program_counter = program_counter + jump
    steps = steps + 1
  end
  return steps
end

local function part2editor(v)
  if(v >=3)
    then return v-1
    else return v+1
  end
end

local memory = read_file("/Users/mariosangiorgio/Downloads/input")
-- part 1 local steps = interpret(memory, function(v)return v+1 end)
-- part 2
local steps = interpret(memory, part2editor)
print (steps)