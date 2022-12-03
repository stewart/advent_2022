defmodule Advent.Day03 do
  use Advent
  input_file "advent/day03.dat"

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
    split_into_compartments = fn str ->
      size = div(byte_size(str), 2)
      <<lhs::binary-size(size), rhs::binary>> = str
      [to_charlist(lhs), to_charlist(rhs)]
    end

    find_shared_items = fn compartments ->
      compartments
      |> map(&MapSet.new/1)
      |> reduce(&MapSet.intersection/2)
    end

    to_priority = fn
      item when item in ?a..?z -> item - ?a + 1
      item when item in ?A..?Z -> item - ?a + ?A - 6
    end

    data
    |> map(split_into_compartments)
    |> flat_map(find_shared_items)
    |> map(to_priority)
    |> sum()
  end

  def part_two(data) do
    into_rucksacks = fn string ->
      string |> to_charlist() |> MapSet.new()
    end

    find_badges = fn rucksacks ->
      reduce(rucksacks, &MapSet.intersection/2)
    end

    to_priority = fn
      item when item in ?a..?z -> item - ?a + 1
      item when item in ?A..?Z -> item - ?a + ?A - 6
    end

    data
    |> map(into_rucksacks)
    |> chunk_every(3)
    |> flat_map(find_badges)
    |> map(to_priority)
    |> sum()
  end
end
