# d(t) = |sx + vx*t +ax*t*(t+1)/2| + |sy + vy*t +ay*t*(t+1)/2| |sy + vy*t +ay*t*(t+1)/2|
defmodule ParticleSwarm do
  def parse(token) do
    String.slice(token,3..-2) |> String.split(",") |> Enum.map(&String.to_integer(&1))
  end
end
input =
File.stream!("/Users/mariosangiorgio/Downloads/input") |>
Stream.map( &(String.replace(&1, "\n", "")) ) |>
Stream.with_index |>
Enum.map(fn({line, index})->
  [p, v, a] = String.split(line, ", ")
  {index, {ParticleSwarm.parse(p), ParticleSwarm.parse(v), ParticleSwarm.parse(a)}}
end)
# Part 1
# For t -> +inf O(d(t))= (|ax| + |ay| |ay|)*t*(t+1)/2
# Assumes no ties in the accelerations
[{index, _}|t]=
input |>
Enum.map( fn({index, {_,_,a}}) ->
  cost = a |> Enum.map(&abs/1) |> Enum.sum
  {index, cost}
end) |>
Enum.sort_by(fn({_, cost}) -> cost end)
IO.write(index)
# Part 2