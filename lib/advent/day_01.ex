defmodule Advent.Day01 do
  use Advent
  input_file("advent/day_01.dat")

  @impl Advent
  def perform do
    data = input()

    IO.inspect(part_one(data), label: :part_one)
    IO.inspect(part_two(data), label: :part_two)
  end

  @impl Advent
  def input do
    for list <- split(@input_file, "\n\n") do
      list
      |> split("\n", trim: true)
      |> map(&to_integer/1)
      |> sum()
    end
  end

  # find the elf carrying the most calories
  def part_one(calories) do
    max(calories)
  end

  # find the three elves carrying the most calories
  def part_two(calories) do
    [uno, dos, tres | _] = sort(calories, :desc)
    sum([uno, dos, tres])
  end
end
