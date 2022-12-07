defmodule Advent do
  @moduledoc false

  @callback input :: any
  @callback perform :: any
  @optional_callbacks [input: 0]

  defmacro __using__(_) do
    quote do
      @moduledoc false
      @behaviour Advent

      import Bitwise
      import Enum, except: [split: 2]
      import Integer, only: [digits: 2, gcd: 2, mod: 2, pow: 2]
      import List, only: [to_tuple: 1, last: 1, delete_at: 2]
      import MapSet, except: [filter: 2, reject: 2]
      import String, except: [to_charlist: 1, last: 1]

      import Advent
    end
  end

  defmacro input_file(filename) do
    path = Path.join([:code.priv_dir(:advent), filename])

    quote do
      @external_resource unquote(path)
      @input_file File.read!(unquote(path))
    end
  end

  def set(enum \\ []), do: MapSet.new(enum)

  def sum(enum, fun) when is_function(fun) do
    enum |> Enum.map(fun) |> Enum.sum()
  end
end
