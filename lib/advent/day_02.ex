defmodule Advent.Day02 do
  use Advent
  input_file("advent/day_02.dat")

  @impl Advent
  def perform do
    strategies = input()

    IO.inspect(part_one(strategies), label: :part_one)
    IO.inspect(part_two(strategies), label: :part_two)
  end

  @impl Advent
  def input do
    @input_file
    |> split()
    |> chunk_every(2)
  end

  def part_one(strategies) do
    score = fn [<<lhs>>, <<rhs>>] ->
      op = lhs - ?A
      us = rhs - ?X
      mod(us - op + 1, 3) * 3 + us + 1
    end

    strategies
    |> map(score)
    |> sum()
  end

  def part_two(strategies) do
    score = fn [<<lhs>>, <<rhs>>] ->
      op = lhs - ?A
      us = mod(op + (rhs - ?X + 2), 3)
      mod(us - op + 1, 3) * 3 + us + 1
    end

    strategies
    |> map(score)
    |> sum()
  end
end
