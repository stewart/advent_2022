defmodule Advent.Day12 do
  use Advent
  input_file("advent/day_12.dat")

  defmodule Heightmap do
    @moduledoc "Breadth-first search!"

    import MapSet

    def new("" <> input) do
      data = input |> split() |> map(&to_charlist/1)

      Map.new(
        for {row, y} <- with_index(data),
            {val, x} <- with_index(row),
            do: {{x, y}, val}
      )
    end

    def search(%{} = map, {_, _} = start, {_, _} = target) do
      bfs(map, target, _visited = set([start]), _queue = [{start, 0}])
    end

    defp bfs(_grid, _target, _visited, [] = _queue), do: :not_found
    defp bfs(_grid, target, _visited, [{target, moves} | _] = _queue), do: moves

    defp bfs(grid, target, visited, [{coords, moves} | tail] = _queue) do
      next =
        for xy <- valid_moves(grid, coords),
            xy not in visited,
            do: {xy, moves + 1}

      visited = union(visited, set(for {xy, _} <- next, do: xy))
      bfs(grid, target, visited, tail ++ next)
    end

    defp valid_moves(%{} = grid, {col, row} = _coords) do
      height = grid[{col, row}]

      for {x, y} <- [{-1, 0}, {1, 0}, {0, -1}, {0, 1}],
          coords = {col + x, row + y},
          Map.has_key?(grid, coords) and grid[coords] - height <= 1,
          do: coords
    end
  end

  @impl Advent
  def perform do
    data = input()

    IO.inspect(part_one(data), label: :part_one)
    IO.inspect(part_two(data), label: :part_two)
  end

  @impl Advent
  def input do
    Heightmap.new(@input_file)
  end

  def part_one(heightmap) do
    start = find_key(heightmap, fn {_, val} -> val == ?S end)
    target = find_key(heightmap, fn {_, val} -> val == ?E end)

    heightmap =
      heightmap
      |> Map.put(start, ?a)
      |> Map.put(target, ?z)

    Heightmap.search(heightmap, start, target)
  end

  def part_two(heightmap) do
    starting_from = for {coords, ?a} <- heightmap, do: coords
    target = find_key(heightmap, fn {_, val} -> val == ?E end)
    heightmap = Map.put(heightmap, target, ?z)
    min(for start <- starting_from, do: Heightmap.search(heightmap, start, target))
  end

  defp find_key(%{} = enum, fun) do
    enum |> find(fun) |> elem(0)
  end
end
