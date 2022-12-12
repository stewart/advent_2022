defmodule Advent.Day11 do
  use Advent
  input_file("advent/day_11.dat")

  defmodule Monkey do
    alias __MODULE__
    defstruct [:id, :items, :inspected, :operation, :test, :on_success, :on_failure]

    def from("Monkey " <> monke) do
      [name | rest] = monke |> split("\n", trim: true) |> map(&trim/1)
      [items, operation, test, on_success, on_failure] = map(rest, &parse/1)
      {id, _} = Integer.parse(name)

      %{
        id: id,
        test: test,
        items: items,
        inspected: 0,
        operation: operation,
        on_success: on_success,
        on_failure: on_failure
      }
    end

    def business(%{} = troop) do
      monkeys = Map.keys(troop)

      reduce(monkeys, troop, fn id, acc ->
        monkey = acc[id]

        reduce(monkey.items, acc, fn item, acc ->
          when_inspected = monkey.operation.(item)
          when_bored = div(when_inspected, 3)

          recipient =
            if monkey.test.(when_bored),
              do: monkey.on_success,
              else: monkey.on_failure

          acc
          |> update_in([id, :items], &tl/1)
          |> update_in([id, :inspected], &(&1 + 1))
          |> update_in([recipient, :items], &(&1 ++ [when_bored]))
        end)
      end)
    end

    defp parse("Test: " <> test) do
      case test do
        "divisible by " <> number ->
          val = to_integer(number)
          &(rem(&1, val) == 0)
      end
    end

    defp parse("Starting items: " <> items) do
      items
      |> split(", ", trim: true)
      |> map(&to_integer/1)
    end

    defp parse("Operation: " <> operation) do
      case split(operation) do
        ["new", "=", "old", op, "old"] ->
          op = operator(op)
          &(apply(op, [&1, &1]))

        ["new", "=", "old", op, value] ->
          {op, val} = {operator(op), to_integer(value)}
          &(apply(op, [&1, val]))
      end
    end

    defp parse("If true: " <> on_success) do
      "throw to monkey " <> monkey = on_success
      to_integer(monkey)
    end

    defp parse("If false: " <> on_failure) do
      "throw to monkey " <> monkey = on_failure
      to_integer(monkey)
    end

    defp operator("*"), do: &Kernel.*/2
    defp operator("+"), do: &Kernel.+/2
    defp operator("-"), do: &Kernel.-/2
  end

  @impl Advent
  def perform do
    data = input()

    IO.inspect(part_one(data), label: :part_one)
    IO.inspect(part_two(data), label: :part_two)
  end

  @impl Advent
  def input do
    @input_file
    |> split("\n\n", trim: true)
    |> map(&Monkey.from/1)
    |> Map.new(&{&1.id, &1})
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
