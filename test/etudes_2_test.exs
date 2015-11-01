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

end
