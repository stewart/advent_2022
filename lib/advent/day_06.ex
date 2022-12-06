defmodule Advent.Day06 do
  use Advent
  input_file("advent/day_06.dat")

  @impl Advent
  def perform do
    data = input()

    IO.inspect(part_one(data), label: :part_one)
    IO.inspect(part_two(data), label: :part_two)
  end

  @impl Advent
  def input do
    @input_file
    |> trim()
    |> to_charlist()
  end

  def part_one(datastream) do
    find_unique_sequence_offset(datastream, _packet = 4)
  end

  def part_two(datastream) do
    find_unique_sequence_offset(datastream, _message = 14)
  end

  def find_unique_sequence_offset(datastream, count)
      when is_list(datastream) and is_integer(count) do
    datastream
    |> chunk_every(count, 1)
    |> with_index(count)
    |> find_value(fn {buffer, offset} -> if buffer == uniq(buffer), do: offset end)
  end
end
