defmodule Etudes4Test do
  use ExUnit.Case
  doctest Etudes4

  test "area of rectangle 4 x 5" do
    assert Etudes4.area({:rectangle,4,5}) == 20
  end

  test "rectangle dimensions should be positive #1" do
    # assert_raise FunctionClauseError, fn -> Etudes4.area(:rectangle,-1,5) end
    assert Etudes4.area({:rectangle,-1,5})
  end

  test "rectangle dimensions should be positive #2" do
    # assert_raise FunctionClauseError, fn -> Etudes4.area(:rectangle,4,-1) end
    assert Etudes4.area({:rectangle,4,-1}) == 0
  end

  test "area of triangle 4 x 5" do
    assert Etudes4.area({:triangle,4,5}) == 10
  end

  test "triangle dimensions should be positive #1" do
    # assert_raise FunctionClauseError, fn -> Etudes4.area(:triangle,-1,5) end
    assert Etudes4.area({:triangle,-1,5})
  end

  test "triangle dimensions should be positive #2" do
    # assert_raise FunctionClauseError, fn -> Etudes4.area(:triangle,4,-1) end
    assert Etudes4.area({:triangle,4,-1}) == 0
  end

  test "area of ellipse 4 x 5" do
    assert Etudes4.area({:ellipse,4,5}) == :math.pi * 4 * 5
  end

  test "ellipse dimensions should be positive #1" do
    # assert_raise FunctionClauseError, fn -> Etudes4.area(:ellipse,-1,5) end
    assert Etudes4.area({:ellipse,-1,5}) == 0
  end

  test "ellipse dimensions should be positive #2" do
    # assert_raise FunctionClauseError, fn -> Etudes4.area(:ellipse,4,-1) end
    assert Etudes4.area({:ellipse,4,-1}) == 0
  end

  test "area of whatever 4 5" do
    assert Etudes4.area({:whatever,4,5}) == 0
  end

  test "calling private is not cool" do
    assert catch_error Etudes4.area(:triangle,4,5) == UndefinedFunctionError
  end

  test "greatest common denominator if zero" do
    assert catch_error Etudes4.gcd(4,0) == ArgumentError
  end

  test "greatest common denominator if equal" do
    assert Etudes4.gcd(4,4) == 4
  end

  test "greatest common denominator if text" do
    assert catch_error Etudes4.gcd(4,"4") == ArgumentError
  end

  test "greatest common denominator if primes" do
    assert Etudes4.gcd(3,5) == 1
  end

  test "greatest common denominator if 1st lower" do
    assert Etudes4.gcd(8,12) == 4
  end

  test "greatest common denominator if 2nd lower" do
    assert Etudes4.gcd(25,20) == 5
  end

  test "number to power 0" do
    assert Etudes4.rpower(4,0) == 1
  end

  test "number to power 1" do
    assert Etudes4.rpower(4,1) == 4
  end

  test "number to power 8" do
    assert Etudes4.rpower(2,8) == 256
  end

  test "number to power -8" do
    assert Etudes4.rpower(2,-8) == 1.0/256.0
  end

end
