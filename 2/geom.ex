defmodule Geom do

  @moduledoc """
  A module to handle Geometric functions.
  """

  @doc """
  Calculate the area of a rectangle.
  """
  def area(x \\ 1, y \\ 1) do
    x*y
  end

  def sum( a \\ 3, b, c \\ 7) do
    a + b + c
  end

end

