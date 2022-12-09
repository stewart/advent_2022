defmodule Advent.Day09 do
  use Advent
  input_file("advent/day_09.dat")

  @impl Advent
  def perform do
    data = input()

    IO.inspect(part_one(data), label: :part_one)
    IO.inspect(part_two(data), label: :part_two)
  end

  @impl Advent
  def input do
    @input_file
    |> split()
    |> chunk_every(2)
    |> flat_map(fn [dir, n] -> for _ <- 1..to_integer(n), do: direction(dir) end)
  end

  def part_one(instructions) do
    instructions
    |> map_reduce(rope(1), &move/2)
    |> then(fn {visited, _} -> uniq(visited) end)
    |> count()
  end

  def part_two(instructions) do
    instructions
    |> map_reduce(rope(9), &move/2)
    |> then(fn {visited, _} -> uniq(visited) end)
    |> count()
  end

  defp rope(length) do
    for _ <- 0..length, do: {0, 0}
  end

  defp direction("D"), do: {0, -1}
  defp direction("L"), do: {-1, 0}
  defp direction("R"), do: {1, 0}
  defp direction("U"), do: {0, 1}

  defp move(dir, [head | tail]) do
    head = move(head, dir)
    tail = follow(tail, head)
    {last(tail), [head | tail]}
  end

  defp move({x, y}, {dx, dy}), do: {x + dx, y + dy}

  defp follow(tail, head, acc \\ [])
  defp follow([], _head, acc), do: Enum.reverse(acc)

  defp follow([{x, y} | tail], {hx, hy}, acc) do
    case {hx - x, hy - y} do
      {dx, dy} when abs(dx) > 1 or abs(dy) > 1 ->
        updated = {x + sign(dx), y + sign(dy)}
        follow(tail, updated, [updated | acc])

      {_x, _y} ->
        follow(tail, {x, y}, [{x, y} | acc])
    end
  end

  defp sign(n) when is_integer(n) and n > 0, do: 1
  defp sign(n) when is_integer(n) and n < 0, do: -1
  defp sign(0), do: 0
end
