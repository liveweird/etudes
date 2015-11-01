defmodule Etudes3 do
  @moduledoc """
    Etudes from chapter #3
  """

  @doc """
    Area of rectangle
  """
  @spec area(atom(), number(), number()) :: number()
  def area(:rectangle, x, y) do
    x * y
  end

  @doc """
    Area of triangle
  """
  @spec area(atom(), number(), number()) :: number()
  def area(:triangle, a, h) do
    (a * h) / 2.0
  end

  @doc """
    Area of ellipse
  """
  @spec area(atom(), number(), number()) :: number()
  def area(:ellipse, a, b) do
    :math.pi * a * b
  end

end
