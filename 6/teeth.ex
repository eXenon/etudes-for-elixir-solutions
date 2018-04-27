defmodule Teeth do

  @moduledoc """
  A module to... whatever. This études has little meaning :p.
  """

  def pocket_depths do
    [[0], [2,2,1,2,2,1], [3,1,2,3,2,3],
    [3,1,3,2,1,2], [3,2,3,2,2,1], [2,3,1,2,1,1],
    [3,1,3,2,3,2], [3,3,2,1,3,1], [4,3,3,2,3,3],
    [3,1,1,3,2,2], [4,3,4,3,2,3], [2,3,1,3,2,2],
    [1,2,1,1,3,2], [1,2,2,3,2,3], [1,3,2,1,3,3], [0],
    [3,2,3,1,1,2], [2,2,1,1,3,2], [2,1,1,1,1,2],
    [3,3,2,1,1,3], [3,1,3,2,3,2], [3,3,1,2,3,3],
    [1,2,2,3,3,3], [2,2,3,2,3,3], [2,2,2,4,3,4],
    [3,4,3,3,3,4], [1,1,2,3,1,2], [2,2,3,2,1,3],
    [3,4,2,4,4,3], [3,3,2,1,2,3], [2,2,2,2,3,3],
    [3,2,3,2,3,2]]
  end


  def alert(teeth) do
    alert(1, teeth, [])
  end

  defp alert(tooth_id, [ [0] | teeth ], acc) do
    alert(tooth_id + 1, teeth, acc)
  end
  defp alert(tooth_id, [ tooth | teeth ], acc) do
    if Stats.maximum(tooth) >= 4 do
      alert(tooth_id + 1, teeth, [ tooth_id | acc ])
    else
      alert(tooth_id + 1, teeth, acc)
    end
  end
  defp alert(_, [], acc) do
    Enum.reverse(acc)
  end


  def generate_

end
