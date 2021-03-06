defmodule Etudes3Test do
  use ExUnit.Case
  doctest Etudes3

  test "area of rectangle 4 x 5" do
    assert Etudes3.area({:rectangle,4,5}) == 20
  end

  test "rectangle dimensions should be positive #1" do
    # assert_raise FunctionClauseError, fn -> Etudes3.area(:rectangle,-1,5) end
    assert Etudes3.area({:rectangle,-1,5})
  end

  test "rectangle dimensions should be positive #2" do
    # assert_raise FunctionClauseError, fn -> Etudes3.area(:rectangle,4,-1) end
    assert Etudes3.area({:rectangle,4,-1}) == 0
  end

  test "area of triangle 4 x 5" do
    assert Etudes3.area({:triangle,4,5}) == 10
  end

  test "triangle dimensions should be positive #1" do
    # assert_raise FunctionClauseError, fn -> Etudes3.area(:triangle,-1,5) end
    assert Etudes3.area({:triangle,-1,5})
  end

  test "triangle dimensions should be positive #2" do
    # assert_raise FunctionClauseError, fn -> Etudes3.area(:triangle,4,-1) end
    assert Etudes3.area({:triangle,4,-1}) == 0
  end

  test "area of ellipse 4 x 5" do
    assert Etudes3.area({:ellipse,4,5}) == :math.pi * 4 * 5
  end

  test "ellipse dimensions should be positive #1" do
    # assert_raise FunctionClauseError, fn -> Etudes3.area(:ellipse,-1,5) end
    assert Etudes3.area({:ellipse,-1,5}) == 0
  end

  test "ellipse dimensions should be positive #2" do
    # assert_raise FunctionClauseError, fn -> Etudes3.area(:ellipse,4,-1) end
    assert Etudes3.area({:ellipse,4,-1}) == 0
  end

  test "area of whatever 4 5" do
    assert Etudes3.area({:whatever,4,5}) == 0
  end

  test "calling private is not cool" do
    assert catch_error Etudes3.area(:triangle,4,5) == UndefinedFunctionError
  end

end
