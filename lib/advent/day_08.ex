defmodule Advent.Day08 do
  use Advent
  input_file("advent/day_08.dat")

  @impl Advent
  def perform do
    trees = input()

    IO.inspect(part_one(trees), label: :part_one)
    IO.inspect(part_two(trees), label: :part_two)
  end

  @impl Advent
  def input do
    rows =
      @input_file
      |> split()
      |> map(&(&1 |> split("", trim: true)))

    for {row, y} <- with_index(rows),
        {val, x} <- with_index(row),
        into: %{},
        do: {{x, y}, to_integer(val)}
  end

  def part_one(trees) do
    max_x = trees |> map(fn {{x, _}, _} -> x end) |> max()
    max_y = trees |> map(fn {{_, y}, _} -> y end) |> max()

    visible? = fn
      # left or right side of the grid
      {{x, _}, _} when x in [0, max_x] ->
        true

      # top or bottom side of the grid
      {{_, y}, _} when y in [0, max_y] ->
        true

      # interior of the grid, actually need to evaluate sightlines
      {{x, y}, height} ->
        sightlines = [
          for(x <- 0..(x - 1), do: {x, y}),
          for(y <- 0..(y - 1), do: {x, y}),
          for(x <- max_x..(x + 1), do: {x, y}),
          for(y <- max_y..(y + 1), do: {x, y})
        ]

        # a sightline is unobstructed if all trees along the way are shorter
        unobstructed_view? = fn coords ->
          all?(coords, &(Map.fetch!(trees, &1) < height))
        end

        # a tree is visible if any of the sightlines have unobstructed views
        any?(sightlines, unobstructed_view?)
    end

    trees
    |> filter(visible?)
    |> count()
  end

  def part_two(trees) do
    max_x = trees |> map(fn {{x, _}, _} -> x end) |> max()
    max_y = trees |> map(fn {{_, y}, _} -> y end) |> max()

    scenic_score = fn
      # left or right side of the grid
      {{x, _}, _} when x in [0, max_x] ->
        0

      # top or bottom side of the grid
      {{_, y}, _} when y in [0, max_y] ->
        0

      # interior of the grid, evaluate a scenic score
      {{x, y}, height} ->
        sightlines = [
          for(x <- (x - 1)..0, do: {x, y}),
          for(y <- (y - 1)..0, do: {x, y}),
          for(x <- (x + 1)..max_x, do: {x, y}),
          for(y <- (y + 1)..max_y, do: {x, y})
        ]

        viewing_distance = fn coords ->
          # a tree blocks our view if is the same height or taller
          blocking_view? = &(Map.fetch!(trees, &1) >= height)

          if idx = find_index(coords, blocking_view?) do
            idx + 1
          else
            length(coords)
          end
        end

        sightlines
        |> map(viewing_distance)
        |> reduce(&Kernel.*/2)
    end

    trees
    |> map(scenic_score)
    |> max()
  end
end
