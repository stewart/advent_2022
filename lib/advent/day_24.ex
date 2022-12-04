defmodule Advent.Day24 do
  use Advent
  input_file("advent/day_24.dat")

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

  def part_one(data) do
    data
  end

  def part_two(data) do
    data
  end
end
