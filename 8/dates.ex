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

  @doc """
  Check if a given year is a leap year.
  """
  
  @spec is_leap_year(integer) :: boolean
  defp is_leap_year(year) do
    (rem(year,4) == 0 and rem(year,100) != 0)
    or (rem(year, 400) == 0)
  end

  @doc """
  Return the Julian date (day of the year) of a given ISO date.
  """

  @spec julian(String.t()) :: integer
  def julian(s) do
    [y, m, d] = date_parts(s)
    if is_leap_year(y) and m > 2 do
      month_total(m) + d + 1
    else
      month_total(m) + d
    end
  end

  @doc """
  Returns the days passed up until the beginning of a given month.
  """
  
  @spec month_total(integer) :: integer
  defp month_total(m) when m <= 12 do
    month_total(m, [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31], 0)
  end
  defp month_total(1, _, acc) do
    acc
  end
  defp month_total(m, [ next_month | month_days ], acc) do
    month_total(m-1, month_days, acc + next_month)
  end


  def julian2(s) do
    [y, m, d] = date_parts(s)
    {months, _} = Enum.split([31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31], m - 1)
    if is_leap_year(y) and m > 2 do
      List.foldl(months, d + 1, fn md, acc -> acc + md end)
    else
      List.foldl(months, d, fn md, acc -> acc + md end)
    end
  end


end
