# d(t) = |sx + vx*t +ax*t*(t+1)/2| + |sy + vy*t +ay*t*(t+1)/2| |sy + vy*t +ay*t*(t+1)/2|
defmodule ParticleSwarm do
  def parse(token) do
    String.slice(token,3..-2) |> String.split(",") |> Enum.map(&String.to_integer(&1))
  end

  def evolve({[sx,sy,sz],[vx,vy,vz],[ax,ay,az]}) do
    {[sx + vx + ax,sy + vy + ay,sz + vz + az],[vx + ax,vy + ay,vz + az],[ax,ay,az]}
  end

  def step(all) do
    all
    |> Enum.map(fn({index, item}) -> {index, evolve(item)} end)
    |> Enum.group_by(fn({_, {p,_,_}}) -> p end)
    |> Enum.filter(fn({_,v}) -> Enum.count(v) == 1 end)
    |> Enum.map(fn({_, [v]}) -> v end)
  end
  def step_loop(all, 0) do
    all
  end
  def step_loop(all, counter) do
    step_loop(step(all), counter - 1)
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
[{index, _}|_]=
input |>
Enum.map( fn({index, {_,_,a}}) ->
  cost = a |> Enum.map(&abs/1) |> Enum.sum
  {index, cost}
end) |>
Enum.sort_by(fn({_, cost}) -> cost end)
IO.write(index)
# Part 2
# Analytical solution would be
# Possible collision times are t such that
# sx1 + vx1*t +ax1*t*(t+1)/2 = sx2 + vx2*t +ax2*t*(t+1)/2
# (sx1-sx2) + [vx1-vx2 + (ax1 - ax2)/2]*t + (ax1-ax2)/2*t^2 = 0
# (da)/2*t^2 + [dv + (da)/2]*t + (ds) = 0
# Take the smallest t and remove the items
# repeat till there is no collision left
ParticleSwarm.step_loop(input, 100) # 100 here is not very principled