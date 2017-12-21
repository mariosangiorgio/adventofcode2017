# d(t) = |sx + vx*t +ax*t*(t+1)/2| + |sy + vy*t +ay*t*(t+1)/2| |sy + vy*t +ay*t*(t+1)/2|
defmodule ParticleSwarm do
  def parse(token) do
    String.slice(token,3..-2) |> String.split(",") |> Enum.map(&String.to_integer(&1))
  end

  def evolve({[sx,sy,sz],[vx,vy,vz],[ax,ay,az]}) do
    {[sx + vx + ax,sy + vy + ay,sz + vz + az],[vx + ax,vy + ay,vz + az],[ax,ay,az]}
  end

  defmacro is_integer_solution(x) do
    quote do: round(unquote(x)) == unquote(x)
  end

  def merge(:none, _, _) do :none end
  def merge(_, :none, _) do :none end
  def merge(_, _, :none) do :none end
  def merge({_, s}, {_, s}, {_, s}) when is_integer_solution(s) do s end
  def merge({_, s}, {_, s}, {s, _}) when is_integer_solution(s) do s end
  def merge({_, s}, {s, _}, {_, s}) when is_integer_solution(s) do s end
  def merge({_, s}, {s, _}, {s, _}) when is_integer_solution(s) do s end
  def merge({s, _}, {_, s}, {_, s}) when is_integer_solution(s) do s end
  def merge({s, _}, {_, s}, {s, _}) when is_integer_solution(s) do s end
  def merge({s, _}, {s, _}, {_, s}) when is_integer_solution(s) do s end
  def merge({s, _}, {s, _}, {s, _}) when is_integer_solution(s) do s end
  def merge(_, _, _) do :none end

  def solve(a, b, c) do
    delta = b*b - 4*a*c
    if delta < 0 do
      :none
    else
      {(-b - :math.sqrt(delta))/2*a, (-b + :math.sqrt(delta))/2*a}
    end
  end

  def latest_collision_time({[x1,y1,z1],[vx1,vy1,vz1],[ax1,ay1,az1]}, {[x2,y2,z2],[vx2,vy2,vz2],[ax2,ay2,az2]}) do
    x = solve((ax1-ax2)/2, (ax1-ax2)/2 + vx1 - vx2, x1 - x2)
    y = solve((ay1-ay2)/2, (ay1-ay2)/2 + vy1 - vy2, y1 - y2)
    z = solve((az1-az2)/2, (az1-az2)/2 + vz1 - vz2, z1 - z2)
    merge(x, y, z)
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
IO.puts(index)
# Part 2
# Analytical solution would be
# Possible collision times are t such that
# sx1 + vx1*t +ax1*t*(t+1)/2 = sx2 + vx2*t +ax2*t*(t+1)/2
# (sx1-sx2) + [vx1-vx2 + (ax1 - ax2)/2]*t + (ax1-ax2)/2*t^2 = 0
# (da)/2*t^2 + [dv + (da)/2]*t + (ds) = 0
# Take the smallest t and remove the items
# repeat till there is no collision left
latest_collision_times =
  for {_, i} <- input, {_, j} <- input, i != j, do: ParticleSwarm.latest_collision_time(i,j)
latest_collision_time = # upper bound, but that's fine
  latest_collision_times |> Enum.filter(&(&1 != :none)) |> Enum.max
left = ParticleSwarm.step_loop(input, round(latest_collision_time)) |> Enum.count
IO.puts(left)