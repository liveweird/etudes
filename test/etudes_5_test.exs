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
    assert Etudes5.get_number([ "Whatever" ], [ fn(_) -> "    1" end ]) == [ 1 ]
  end

  test "get simple '1', check good prompt" do
    assert Etudes5.get_number([ "Whatever" ], [ fn("Whatever") -> "    1" end ]) == [ 1 ]
  end

  test "get simple '1', check wrong prompt" do
    assert_raise FunctionClauseError, fn -> Etudes5.get_number([ "Whatever" ], [ fn("Anything") -> "    1" end ]) end
  end

  test "get non-numeric value" do
    assert Etudes5.get_number([ " Whatever" ], [ fn(_) -> "   aaaa  " end, fn(_) -> "2" end ]) == [ 2 ]
  end

  test "get values with 2 digits" do
    assert Etudes5.get_number([ "Whatever" ], [ fn(_) -> " 23 " end ]) == [ 23 ]
  end

  test "get with 2 numeric values" do
    assert Etudes5.get_number([ "Whatever" ], [ fn(_) -> " 2 34 " end ]) == [ 2 ]
  end

  test "get 2 proper numeric values" do
    assert Etudes5.get_dimensions("Whatever", "Anything", [ fn(_) -> "2" end, fn(_) -> "5" end ]) == [ 2, 5 ]
  end

  test "get 2 proper numeric values, check good prompts" do
    assert Etudes5.get_dimensions("ABC", "DEF", [ fn("ABC") -> "2" end, fn("DEF") -> "5" end ]) == [ 2, 5 ]
  end

  test "get 2 proper numeric values, check wrong prompts #1" do
    assert_raise FunctionClauseError, fn -> Etudes5.get_dimensions("ABC", "DEF", [ fn("ABC") -> "2" end, fn("XYZ") -> "5" end ]) end
  end

  test "get 2 proper numeric values, check wrong prompts #2" do
    assert_raise FunctionClauseError, fn -> Etudes5.get_dimensions("ABC", "DEF", [ fn("XYZ") -> "2" end, fn("ABC") -> "5" end ]) end
  end

end
