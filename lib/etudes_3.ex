defmodule Etudes3 do
  @moduledoc """
    Etudes from chapter #3
  """

  @spec area(atom(), number(), number()) :: number()
  defp area(:rectangle, x, y) when x > 0 and y > 0 do
    x * y
  end

  @spec area(atom(), number(), number()) :: number()
  defp area(:triangle, a, h) when a > 0 and h > 0 do
    (a * h) / 2.0
  end

  @spec area(atom(), number(), number()) :: number()
  defp area(:ellipse, a, b) when a > 0 and b > 0 do
    :math.pi * a * b
  end

  defp area(_, _, _) do
    0
  end

  @doc """
    Area of whatever
  """
  def area({a,b,c}) do
    area(a,b,c)
  end

end
