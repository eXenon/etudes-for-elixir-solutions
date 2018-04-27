defmodule NonFP do

  @moduledoc """
  All non pure functions (random functions for example)
  are isolated in this module.
  """

  def generate_pockets(s, p) do
    generate_pockets(s, p, [])
  end
  defp generate_pockets([], _, acc) do
    Enum.reverse(acc)
  end
  defp generate_pockets([ ?F | t ], p, acc) do
    generate_pockets(t, p, [ [0] | acc ])
  end
  defp generate_pockets([ ?T | t ], p, acc) do
    generate_pockets(t, p, [ generate_tooth(p) | acc ])
  end
    

  defp generate_tooth(p) do
    if :rand.uniform() > p do
      generate_tooth(2, 6, [])
    else
      generate_tooth(3, 6, [])
    end
  end
  defp generate_tooth(_, 0, acc) do
    acc
  end
  defp generate_tooth(b, n, acc) do
    generate_tooth(b, n - 1, [ b + :rand.uniform(3) - 2 | acc ])
  end

end
