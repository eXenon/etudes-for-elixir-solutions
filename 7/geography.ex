defprotocol Valid do
  @doc """
  A generic validation protocol.
  """
  def valid?(data)
end

defmodule Country do
  defstruct cities: [], language: "", name: ""
end

defmodule City do
  defstruct name: "", latitude: 0, longitude: 0, population: 0
end

defimpl Inspect, for: City do
  def inspect(c, _) do
    "#{c.name} (#{c.population}), Coordinates : #{round(c.longitude * 100) / 100}°N, #{round(c.latitude * 100) / 100}°E"
  end
end

defimpl Valid, for: City do
  def valid?(c) do
    (c.population >= 0) and (c.latitude >= -90) and (c.latitude <= 90) and (c.longitude >= -180) and (c.longitude <= 180)
  end
end

defmodule Geography do

  @moduledoc """
  A module to train manipulating structures.
  """

  @vsn 1.0


  @doc """
  Read a file and make it into a list of structures.
  """

  @spec make_geo_list(String.t) :: [%Country{}]
  def make_geo_list(f) do
    {:ok, device} = File.open(f, [:read, :utf8])
    device
    |> IO.read(:line)
    |> clean_line
    |> make_geo_list(device, [])
  end

  # Version to start a new country
  defp make_geo_list([country, language], device, acc) do
    device
    |> IO.read(:line)
    |> clean_line
    |> make_geo_list(device, acc, %Country{cities: [], language: language, name: country})
  end

  # Version to accumulate cities of a country
  defp make_geo_list([ name, pop, long, lat ], device, acc,
                     %Country{cities: cities, language: language, name: country}) do
    device
    |> IO.read(:line)
    |> clean_line
    |> make_geo_list(device, acc, %Country{cities: [ %City{name: name, population: String.to_integer(pop),
                                                           latitude: String.to_float(lat), 
                                                           longitude: String.to_float(long)} | cities ],
                                           language: language, name: country})
  end

  # Version to start a new country after one ended
  defp make_geo_list( [ c, l ], d, acc, country) do
    make_geo_list( [ c, l ], d, [ country | acc ])
  end

  # Final cleanup
  defp make_geo_list(:eof, d, acc, c) do
    File.close(d)
    [ c | acc ]
  end

  # Helper
  defp clean_line(:eof) do
    :eof
  end
  defp clean_line(l) do
    l
    |> String.trim
    |> String.split(",")
  end


  @doc """
  Calculate total population speaking a given language
  """

  @spec total_population([%Country{}], String.t) :: integer

  def total_population(clist, lang) do
    total_population(clist, lang, 0)
  end

  defp total_population([ %Country{language: l,cities: c} | tl ], l, acc) do
    total_population(tl, l, List.foldl(c, acc, fn x, a -> x.population + a end))
  end
  defp total_population([ _ | tl ], l, acc) do
    total_population(tl, l, acc)
  end
  defp total_population( [], _, acc) do
    acc
  end

end
