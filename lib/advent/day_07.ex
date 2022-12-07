defmodule Advent.Day07 do
  use Advent
  input_file("advent/day_07.dat")

  @impl Advent
  def perform do
    filesystem = input()

    IO.inspect(part_one(filesystem), label: :part_one)
    IO.inspect(part_two(filesystem), label: :part_two)
  end

  @impl Advent
  def input do
    @input_file
    |> split("\n", trim: true)
    |> map(&split/1)
    |> reduce({[], %{}}, fn
      ["$", "cd", "/"], {_, acc} -> {["/"], acc}
      ["$", "cd", ".."], {path, acc} -> {delete_at(path, -1), acc}
      ["$", "cd", path], {prev, acc} -> {prev ++ [path], acc}
      ["$", "ls"], {path, acc} -> {path, put_in(acc, path, %{})}
      ["dir", name], {path, acc} -> {path, put_in(acc, path ++ [name], %{})}
      [size, name], {path, acc} -> {path, put_in(acc, path ++ [name], to_integer(size))}
    end)
    |> then(fn {_, %{"/" => fs}} -> fs end)
  end

  def part_one(filesystem) do
    filesystem
    |> list_directories()
    |> map(&size_on_disk(&1))
    |> filter(&(&1 < 100_000))
    |> sum()
  end

  @capacity 70_000_000
  @required 30_000_000

  def part_two(filesystem) do
    unused = @capacity - sum(filesystem, &size_on_disk/1)

    filesystem
    |> list_directories()
    |> map(&size_on_disk(&1))
    |> sort()
    |> find(&(unused + &1 > @required))
  end

  defp list_directories(%{} = filesystem) do
    flat_map(filesystem, fn
      {name, %{} = children} -> [{name, children} | list_directories(children)]
      {_name, _size} -> []
    end)
  end

  defp size_on_disk({_, size}) when is_integer(size), do: size
  defp size_on_disk({_, %{} = children}), do: sum(children, &size_on_disk/1)
end
