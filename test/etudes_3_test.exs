defmodule Etudes3Test do
  use ExUnit.Case
  doctest Etudes3

  test "area of rectangle 4 x 5" do
    assert Etudes3.area(:rectangle,4,5) == 20
  end

  test "area of triangle 4 x 5" do
    assert Etudes3.area(:triangle,4,5) == 10
  end

  test "area of ellipse 4 x 5" do
    assert Etudes3.area(:ellipse,4,5) == :math.pi * 4 * 5
  end

end
