# d(t) = |sx + vx*t +ax*t*(t+1)/2| + |sy + vy*t +ay*t*(t+1)/2| |sy + vy*t +ay*t*(t+1)/2|
lines =
File.stream!("/Users/mariosangiorgio/Downloads/input") |>
Stream.map( &(String.replace(&1, "\n", "")) ) |>
Stream.with_index |>
Enum.map(fn({line, index})->{line, index} end)
# Part 1
# For t -> +inf O(d(t))= (|ax| + |ay| |ay|)*t*(t+1)/2
# Assumes no ties in the accelerations
[{index, _}|t]=
lines |>
Enum.map( fn({line, index}) ->
  [p, v, a] = String.split(line, " ")
  [ax, ay, az] = String.slice(a,3..-2) |> String.split(",") |> Enum.map(&String.to_integer(&1))
  cost = [ax, ay, az] |> Enum.map(&abs/1) |> Enum.sum
  {index, cost}
end) |>
Enum.sort_by(fn({_, cost}) -> cost end)
IO.write(index)