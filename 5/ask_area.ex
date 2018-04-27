defmodule AskArea do

  @moduledoc """
  Module to calculate area from user input.
  """

  @vsn 1.0

  @doc """
  Start the user input process.
  """

  @spec area() :: number()

  def area do
    i = IO.gets("R)ectangle, T)riangle, or E)llipse:")
    shape = i |> char_to_shape
    {s, {d1, d2}} = case shape do
      :rectangle -> {shape, get_dimensions("width", "height")}
      :triangle  -> {shape, get_dimensions("base", "height")}
      :ellipse   -> {shape, get_dimensions("long radius", "short radius")}
      _          -> {i, {0, 0}}
    end
    calculate(s, d1, d2)
  end

  @doc """
  Transform a user input into a shape atom.
  """

  @spec char_to_shape(String.t()) :: atom()

  defp char_to_shape(c) do
    c2 = c |> String.first |> String.upcase
    case c2 do
      "R" -> :rectangle
      "T" -> :triangle
      "E" -> :ellipse
      _   -> :unknown
    end
  end

  @doc """
  Get a user input number. No validation done here !
  """

  @spec get_number(String.t()) :: integer()  

  defp get_number(s) do
    s = IO.gets("Enter #{s} >") |> String.strip
    cond do
      Regex.match?(~r/^[0-9]+$/, s) -> String.to_integer(s)
      Regex.match?(~r/^[0-9]+\.[0-9]+$/, s) -> String.to_float(s)
      Regex.match?(~r/^[0-9]+\.[0-9]+e-?[0-9]+$/, s) -> String.to_float(s)
      true -> "NaN"
    end
  end

  @doc """
  Shortcut to get two dimensions given two prompts.
  """
  
  @spec get_dimensions(String.t(), String.t()) :: { integer(), integer() }

  defp get_dimensions(p1, p2) do
    { get_number(p1), get_number(p2) }
  end

  @doc """
  The function that will tie everything together.
  """

  @spec calculate(atom(), integer(), integer()) :: integer()

  defp calculate(_, a, b) when a == "NaN" or b == "NaN" do
    IO.puts "Both dimensions need to be numbers."
  end
  defp calculate(s, _, _) when is_bitstring(s) do
    IO.puts "Unknown shape #{s}"
  end
  defp calculate(:unknown, _, _) do
    IO.puts "Unknown shape."
  end
  defp calculate(_, a, b) when a < 0 or b < 0 do
    IO.puts "Both dimensions need to be positive."
  end
  defp calculate(s, a, b) do
    Geom.area({s, a, b})
  end
    

end
