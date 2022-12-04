defmodule Advent.Day11 do
  use Advent
  input_file("advent/day_11.dat")

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
  end

  def part_one(troop) do
    troop = reduce(1..20, troop, fn _, acc -> Monkey.business(acc) end)
    [one, two | _] = sort(for({_, %{inspected: count}} <- troop, do: count), :desc)
    one * two
  end

  def part_two(data) do
    data
  end
end
