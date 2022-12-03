defmodule Advent do
  @moduledoc false

  @callback input :: any
  @callback perform :: any
  @optional_callbacks [input: 0]

  defmacro __using__(_) do
    quote do
      @moduledoc false
      @behaviour Advent
      import Advent

      import Enum, warn: false, except: [split: 2]
      import List, only: [to_tuple: 1]
      import Integer, only: [mod: 2]
      import String, warn: false, except: [to_charlist: 1]
    end
  end

  defmacro input_file(filename) do
    path = Path.join([:code.priv_dir(:advent), filename])

    quote do
      @external_resource unquote(path)
      @input_file File.read!(unquote(path))
    end
  end
end
