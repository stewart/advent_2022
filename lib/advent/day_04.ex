defmodule Advent.Day04 do
  use Advent
  input_file "advent/day04.dat"

  @impl Advent
  def perform do
    data = input()

    IO.inspect(part_one(data), label: :part_one)
    IO.inspect(part_two(data), label: :part_two)
  end

  @impl Advent
  def input do
    @input_file
    |> split(~r/[\s,-]/, trim: true)
    |> map(&to_integer/1)
    |> chunk_every(2)
    |> map(fn [start, stop] -> start..stop end)
    |> map(&MapSet.new/1)
    |> chunk_every(2)
  end

  def part_one(data) do
    is_redundant_assignment? = fn [lhs, rhs] ->
      MapSet.subset?(lhs, rhs) or MapSet.subset?(rhs, lhs)
    end

    count(data, is_redundant_assignment?)
  end

  def part_two(data) do
    has_overlap? = fn [lhs, rhs] ->
      not MapSet.disjoint?(lhs, rhs)
    end

    count(data, has_overlap?)
  end
end
