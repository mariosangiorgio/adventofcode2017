using Base.Test

function solve(chars, offset::Int)
  sum = 0
  len = length(chars)
  for i in 1:len
    # 1-base indexing is a bit weird for this
    if chars[i] == chars[(i - 1 + offset)%len + 1]
      sum += parse(Int, chars[i])
    end
  end
  sum
end

@test solve("1122", 1) == 3
@test solve("1234", 1) == 0
@test solve("91212129", 1) == 9
@test solve("1212", 2) == 6
@test solve("1221", 2) == 0
@test solve("123425", 3) == 4
@test solve("123123", 3) == 12
@test solve("12131415", 4) == 4

open("/Users/mariosangiorgio/Downloads/input") do input
  chars = strip(readstring(input))
  println(solve(chars, 1))
  println(solve(chars, length(chars)/2))
end
