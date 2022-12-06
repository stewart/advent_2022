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

  def part_one(data) do
    start_of_packet? = fn {buffer, offset} ->
      if buffer == uniq(buffer), do: offset
    end

    data
    |> chunk_every(4, 1)
    |> with_index(4)
    |> find_value(start_of_packet?)
  end

  def part_two(data) do
    start_of_message? = fn {buffer, offset} ->
      if buffer == uniq(buffer), do: offset
    end

    data
    |> chunk_every(14, 1)
    |> with_index(14)
    |> find_value(start_of_message?)
  end
end
