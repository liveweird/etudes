defmodule Etudes4 do
  @moduledoc """
    Etudes from chapter #4
  """

  @doc """
    Area of whatever
  """
  @spec area(tuple()) :: number()
  def area({x,y,z}) do
    case {x,y,z} do
      {:triangle,a,h} when a > 0 and h > 0 -> (a * h) / 2.0
      {:ellipse,a,b} when a > 0 and b > 0 -> :math.pi * a * b
      {:rectangle,a,b} when a > 0 and b > 0 -> a * b
      _ -> 0
    end
  end

end
