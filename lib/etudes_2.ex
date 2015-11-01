defmodule Etudes2 do
  @moduledoc """
    Etudes from chapter #2
  """

  @doc """
    Area of rectangle
  """
  @spec area(number(), number()) :: number()
  def area(x \\ 1,y \\ 1) do
    x * y
  end
end
