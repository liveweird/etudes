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

  @doc """
    Greatest common denominator
  """
  @spec gcd(number(), number()) :: number()
  def gcd(x, y) when x > 0 and y > 0 do
    cond do
      x == y -> x
      x < y -> gcd(y - x, x)
      y < x -> gcd(x - y, y)
    end
  end

  @doc """
    Raise x to power n
  """
  @spec rpower(number(), number()) :: number()
  def rpower(x, n) do
    case {x,n} do
      {a,0} -> 1
      {a,b} when b > 0 -> a * rpower a, (b - 1)
      {a,b} when b < 0 -> 1 / rpower a, (b * -1)
    end
  end
end
