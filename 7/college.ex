defmodule College do

  @moduledoc """
  A module to parse files and manipulate hashes.
  """

  @vsn 1.0

  @doc """
  Make a HashDict from a Courses file.
  """

  @spec make_room_list(String.t()) :: %{}

  def make_room_list(f) do
    {:ok, device} = File.open(f, [:read, :utf8])
    make_room_list(IO.read(device, :line), device, %{})
  end
  defp make_room_list(:eof, _, acc) do
    acc
  end
  defp make_room_list(l, d, acc) do
    [ _, course_name, room ] = l |> String.trim |> String.split(",")
    if acc[room] == nil do
      make_room_list(IO.read(d, :line), d, Map.put_new(acc, room, [course_name]))
    else
      make_room_list(IO.read(d, :line), d, Map.put(acc, room, [ course_name | acc[room]]))
    end
  end

end
