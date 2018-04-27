defmodule PhoneEts do

  @moduledoc """
  A module to handle phone calling history stored in ETS.
  """

  @doc """
  Read a file and insert it into the ETS
  """

  @spec setup(String.t) :: [%{}]
  def setup(f) do
    {:ok, device} = File.open(f, [:read, :utf8])
    :ets.new(:history, [:set, :protected, :named_table])
    device
    |> IO.read(:line)
    |> setup(0, device)
  end
  def setup(:eof, _, device) do
    File.close(device)
  end
  def setup(line, line_id, device) do
    line
    |> String.trim
    |> String.split(",")
    |> List.to_tuple
    |> (&(:ets.insert(:history, Tuple.insert_at(&1, 0, line_id)))).()
    device
    |> IO.read(:line)
    |> setup(line_id + 1, device)
  end

  @doc """
  Summary : count call per number.
  """
  def summary() do
    summary(1, :ets.lookup(:history, 0), %{}, :all)
  end
  def summary(number) do
    summary(1, :ets.lookup(:history, 0), %{}, number)
  end
  def summary(_, [], acc, filter) do
    case filter do
      :all   -> acc
      number -> %{ number => acc[number] }
    end
  end
  def summary(next_id, [{_, phn, sd, st, ed, et}], acc, filter) do
    summary(next_id + 1, :ets.lookup(:history, next_id), Map.update(acc, phn, duration(sd,st,ed,et),
                                                                           &(&1 + duration(sd,st,ed,et))),
                                                         filter)
  end

  @doc """
  Submethod to get the duration, in minutes, of a call.
  """
  defp duration(sd, st, ed, et) do
    div(:calendar.datetime_to_gregorian_seconds({string2tuple(ed, "-"),
                                             string2tuple(et, ":")}) \
     - :calendar.datetime_to_gregorian_seconds({string2tuple(sd, "-"),
                                                string2tuple(st, ":")}), 60)
  end

  @doc """
  Convert string to tuple of ints
  """
  defp string2tuple(s, sep) do
    List.to_tuple(Enum.map(String.split(s, sep), fn x -> String.to_integer(x) end))
  end

end
