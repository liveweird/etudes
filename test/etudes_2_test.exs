defmodule Etudes2Test do
  use ExUnit.Case
  doctest Etudes2

  test "area of 4 x 5" do
    assert Etudes2.area(4,5) == 20
  end

  test "area of default * default" do
    assert Etudes2.area == 1
  end

  test "area of 5 * default" do
    assert Etudes2.area(5) == 5
  end

  test "sum of 3" do
    assert Etudes2.sum(11,22,33) == 66
  end

  test "sum of 2" do
    assert Etudes2.sum(11,22) == 40
  end

  test "sum of 1" do
    assert Etudes2.sum(11) == 21
  end

end
