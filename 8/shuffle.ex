defmodule Shuffle do

  @moduledoc """
  A module to shuffle a list.
  """

  @doc """
  This shuffle algorithm will recursively take one random element of a list
  and add it to the aggregator. This is done until the initial list is empty.

  The magic happens in the third definition of this function :
  - Split the list at a random point
  - Take the first element of the second part of the split
  - Add it the aggregator
  - Merge the first part of the split with the remainder of the second part
  - Repeat until the list is empty
  """

  def shuffle(list) do
    :random.seed(:erlang.now())
    shuffle(list, [])
  end

  def shuffle([], acc) do
    acc
  end

  def shuffle(list, acc) do
    {leading, [h | t]} =
      Enum.split(list, :random.uniform(Enum.count(list)) - 1)
      shuffle(leading ++ t, [h | acc])
  end
end
