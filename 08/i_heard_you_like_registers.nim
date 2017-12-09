import tables, strutils, sequtils

var state = initTable[string, int]()

var running_max = 0
for line in lines "/Users/mariosangiorgio/Downloads/input":
  let tokens = splitWhitespace(line)
  let condition_variable_value = getOrDefault(state, tokens[4])
  let condition_value = parseInt(tokens[6])
  var should_execute : bool
  case tokens[5]
  of ">":
    should_execute = condition_variable_value > condition_value
  of "<":
    should_execute = condition_variable_value < condition_value
  of ">=":
    should_execute = condition_variable_value >= condition_value
  of "<=":
    should_execute = condition_variable_value <= condition_value
  of "==":
    should_execute = condition_variable_value == condition_value
  of "!=":
    should_execute = condition_variable_value != condition_value
  else:
      raise newException(Exception, "invalid operator")
  if should_execute:
    let variable = tokens[0]
    let value = getOrDefault(state, variable)
    let operand = parseInt(tokens[2])
    case tokens[1]
    of "inc":
      state[variable] = value + operand
    of "dec":
      state[variable] = value - operand
    else:
      raise newException(Exception, "invalid operator")
    if state[variable] > running_max:
      running_max = state[variable]
echo running_max
var max = 0
for value in state.values:
  if value > max:
    max = value
echo max