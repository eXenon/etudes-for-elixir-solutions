defmodule Stats do

  @moduledoc """
  A module to calculate various statistics about lists.
  """
  
  @vsn 1.0

  @doc """
  Get the minimum of a list.
  """
  
  @spec minimum(nonempty_list(number())) :: number()
  def minimum([h | t]) do
    minimum(t, h)
  end
  defp minimum([h | t], acc) do
    if acc < h do
      minimum(t, acc)
    else  
      minimum(t, h)
    end
  end
  defp minimum([], acc) do
    acc
  end 
  

  @doc """
  Get the maximum of a list.
  """
  
  @spec maximum(nonempty_list(number())) :: number()
  def maximum([h | t]) do
    maximum(t, h)
  end
  defp maximum([h | t], acc) do
    if acc > h do
      maximum(t, acc)
    else  
      maximum(t, h)
    end
  end
  defp maximum([], acc) do
    acc
  end 

  @doc """
  Get the minimum and maximum of a given list.
  """
  
  @spec range(nonempty_list(number())) :: [number()]
  def range(l) do
    [minimum(l), maximum(l)]
  end

end
