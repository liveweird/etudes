defmodule Etudes5Test do
  use ExUnit.Case
  doctest Etudes5

  require Logger
  require IEx

  test "recognize triangle" do
    assert Etudes5.char_to_shape("t") == :triangle
    assert Etudes5.char_to_shape("T") == :triangle
    assert Etudes5.char_to_shape("twhatever") == :triangle
    assert Etudes5.char_to_shape("TWHATEVER") == :triangle
  end

  test "recognize ellipse" do
    assert Etudes5.char_to_shape("e") == :ellipse
    assert Etudes5.char_to_shape("E") == :ellipse
    assert Etudes5.char_to_shape("ewhatever") == :ellipse
    assert Etudes5.char_to_shape("EWHATEVER") == :ellipse
  end

  test "recognize rectanglee" do
    assert Etudes5.char_to_shape("r") == :rectangle
    assert Etudes5.char_to_shape("R") == :rectangle
    assert Etudes5.char_to_shape("rwhatever") == :rectangle
    assert Etudes5.char_to_shape("RWHATEVER") == :rectangle
  end

  test "recognize unrecognizable" do
    assert Etudes5.char_to_shape("x") == :unknown
    assert Etudes5.char_to_shape("xr") == :unknown
    assert Etudes5.char_to_shape("xR") == :unknown
    assert Etudes5.char_to_shape("xt") == :unknown
    assert Etudes5.char_to_shape("xT") == :unknown
    assert Etudes5.char_to_shape("xe") == :unknown
    assert Etudes5.char_to_shape("xE") == :unknown
  end

  test "get simple '1'" do
    assert Etudes5.get_number("Whatever", [ fn -> "    1" end ]) == 1
  end

  test "get non-numeric value" do
    assert Etudes5.get_number("Whatever", [ fn -> "   aaaa  " end, fn -> "2" end ]) == 2
  end

  test "get values with 2 digits" do
    assert Etudes5.get_number("Whatever", [ fn -> " 23 " end ]) == 23
  end

  test "get with 2 numeric values" do
    assert Etudes5.get_number("Whatever", [ fn -> " 2 34 " end ]) == 2
  end

end
