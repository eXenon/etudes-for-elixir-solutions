defmodule Weather do
  use GenServer

  @moduledoc """
  A GenServer module to query the weather at a given location.
  """

  @doc """
  Start link.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Init the service.
  """
  def init(:ok) do
    :inets.start
    {:ok, []}
  end

  @doc """
  Handle a call for a given weather station.
  """
  def handle_cast("", history) do
    IO.puts "Recently viewed #{Enum.join(history, ",")}"
    {:noreply, history}
  end
  def handle_call(location, _from, history)do
    {:reply, query_weather(location), [ location | history ]}
  end

  @doc """
  Actual weather query. Please use your imagination.
  Parsing stuff is boring without external libraries. I'll take it like this.
  """
  defp query_weather(location) do
    [location: location <> ", NY",
     observation_time_rfc822: "Sun, 06 Jul 2014 13:56:00 -0400",
     weather: "A Few Clouds", temperature_string: "80.0 F (26.6 C)"]
  end

  @doc """
  Wrapper for the GenServer call
  """
  def report(location) do
    GenServer.call({:global, __MODULE__}, location)
  end
  def recent do
    GenServer.cast({:global, __MODULE__}, "")
  end

  @doc """
  Multi node \o/
  """
  def connect(node) do
    :net_adm.ping(String.to_atom(node <> "@ns341786"))
  end

end


defmodule WeatherSupervisor do
  use Supervisor

  @moduledoc """
  A supervisor for the weather module.
  """

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: {:global, __MODULE__})
  end

  def init(:ok) do
    children = [
      {Weather, name: {:global, __MODULE__}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end

