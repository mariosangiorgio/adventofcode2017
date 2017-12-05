local function read_file(path)
    local lines = {}
    for line in io.lines(path) do
      lines[#lines + 1] = tonumber(line) // index starts at 1
    end
    return lines
end

local program_counter = 1
local steps = 0
local memory = read_file("/Users/mariosangiorgio/Downloads/input")
while(program_counter <= #memory)do
  local jump = memory[program_counter]
  memory[program_counter] = jump + 1
  program_counter = program_counter + jump
  steps = steps + 1
end
print (steps)