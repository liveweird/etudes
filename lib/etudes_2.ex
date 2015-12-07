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

  @doc """
    Just a basic sum, with some default params

    iex> Etudes2.sum(1,2,3)
    6

    iex> Etudes2.sum(2)
    12

    iex> Etudes2.sum("A")
    ** (ArithmeticError) bad argument in arithmetic expression
  """
  @spec sum(number() | nil, number(), number() | nil) :: number()
  def sum( a \\ 3, b, c \\ 7) do
    a + b + c
  end

end
