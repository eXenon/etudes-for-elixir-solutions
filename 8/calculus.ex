defmodule Calculus do

  @moduledoc """
  A module to do calculus operations.
  """

  @doc """
  Approximate the derivative of a function in a given point.
  """

  @spec derivative((number -> number), number) :: float
  def derivative(f, x) do
    (f.(x + 1.0e-10) - f.(x)) / 1.0e-10
  end

  @doc """
  Stupid comment to contain the code involved in the études 8-2 :

  [{"Federico", "M", 22}, {"Kim", "F", 45}, {"Hansa", "F", 30},
  {"Tran", "M", 47}, {"Cathy", "F", 32}, {"Elias", "M", 50}]

  for {n, g, a} <- l, a >= 40, g == "M", do: n
  for {n, g, a} <- l, a >= 40 or g == "M", do: n
  for {n, "M", a} <- l, a >= 40, do: n

  """

end
