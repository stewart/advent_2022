defmodule Advent.Day10 do
  use Advent
  input_file("advent/day_10.dat")

  defmodule CRT do
    @moduledoc false
    import String, only: [to_integer: 1]

    def parse(instruction) do
      case instruction do
        "add" <> <<register::binary-size(1), " ", n::binary>> ->
          {:add, register, to_integer(n)}

        "noop" ->
          :noop
      end
    end

    def execute([_ | _] = instructions) do
      tick = fn
        {:add, _key, val}, {tick, state} ->
          {[{tick, state}, {tick + 1, state}], {tick + 2, state + val}}

        :noop, {tick, state} ->
          {[{tick, state}], {tick + 1, state}}
      end

      instructions
      |> Enum.flat_map_reduce({1, 1}, tick)
      |> then(fn {cycles, _} -> Map.new(cycles) end)
    end
  end

  @impl Advent
  def perform do
    instructions = input()

    IO.inspect(part_one(instructions), label: :part_one)
    IO.inspect(part_two(instructions), label: :part_two)
  end

  @impl Advent
  def input do
    @input_file
    |> split("\n", trim: true)
    |> map(&CRT.parse/1)
  end

  def part_one(instructions) do
    states = CRT.execute(instructions)
    sum(for n <- [20, 60, 100, 140, 180, 220], do: n * states[n])
  end

  def part_two(instructions) do
    states = CRT.execute(instructions)

    for ticks <- chunk_every(1..map_size(states), 40) do
      for {tick, x} <- with_index(ticks), into: "" do
        match? = states[tick] in [x - 1, x, x + 1]
        if match?, do: "#", else: "."
      end
    end
  end
end
