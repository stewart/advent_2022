defmodule Advent.Day05 do
  use Advent
  input_file("advent/day_05.dat")

  defmodule Stacks do
    @moduledoc false

    def operate(["move", count, "from", from, "to", to], stacks, opts \\ []) do
      batch = Keyword.get(opts, :batch, false)
      container_count = String.to_integer(count)
      {containers, updated_from} = Enum.split(stacks[from], container_count)
      new_containers = if batch, do: Enum.reverse(containers), else: containers

      stacks
      |> Map.put(to, new_containers ++ stacks[to])
      |> Map.put(from, updated_from)
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
    [head, tail] = split(@input_file, "\n\n", parts: 2, trim: true)

    layout =
      head
      |> split("\n")
      |> map(&graphemes/1)
      |> zip_with(& &1)
      |> filter(fn col ->
        <<ch>> = last(col)
        ch in ?0..?9
      end)
      |> map(fn col -> reject(col, &(&1 == " ")) end)
      |> map(fn col ->
        [name | items] = Enum.reverse(col)
        {name, Enum.reverse(items)}
      end)
      |> into(%{})

    instructions =
      tail
      |> split()
      |> chunk_every(6)

    [layout, instructions]
  end

  def part_one([layout, instructions]) do
    instructions
    |> reduce(layout, &Stacks.operate/2)
    |> map(fn {_, containers} -> List.first(containers) end)
    |> join("")
  end

  def part_two([layout, instructions]) do
    instructions
    |> reduce(layout, &Stacks.operate(&1, &2, batch: true))
    |> map(fn {_, containers} -> List.first(containers) end)
    |> join("")
  end
end
