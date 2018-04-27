defmodule Geom do

  def area({t, x, y}) do
    area(t, x, y)
  end

  defp area(:rectangle, x, y) when x >= 0 and y >= 0 do
    x * y
  end
  defp area(:triangle, x, y) when x >= 0 and y >= 0 do
    x * y * 0.5
  end
  defp area(:ellipse, x, y) when x >= 0 and y >= 0 do
    :math.pi * x * y
  end
  defp area(_, _, _) do
    0
  end



end
