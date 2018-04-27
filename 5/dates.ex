defmodule Dates do

  @moduledoc """
  Module to parse dates.
  """

  @vsn 1.0

  @doc """
  A simple function that will split an ISO date into parts, without any error correction.
  """

  @spec date_parts(String.t()) :: [integer]

  def date_parts(s) do
    s
    |> String.split("-")
    |> Enum.map(&(String.to_integer(&1)))
  end

end
