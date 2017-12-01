using Base.Test

function part1(chars)
  sum = 0
  len = length(chars)
  for i in 1:len
    if chars[i] == chars[i%len + 1]
      sum += parse(Int, chars[i])
    end
  end
  sum
end

@test part1("1122") == 3
@test part1("1234") == 0
@test part1("91212129") == 9

function part2(chars)
  sum = 0
  len = length(chars)
  offset = Int(len/2)
  for i in 1:len
    # 1-base indexing is a bit weird for this
    if chars[i] == chars[(i -1 + offset) % len + 1]
      sum += parse(Int, chars[i])
    end
  end
  sum
end

@test part2("1212") == 6
@test part2("1221") == 0
@test part2("123425") == 4
@test part2("123123") == 12
@test part2("12131415") == 4

open("/Users/mariosangiorgio/Downloads/input") do input
  chars = strip(readstring(input))
  println(part1(chars))
  println(part2(chars))
end
