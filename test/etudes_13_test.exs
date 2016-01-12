defmodule Etudes13Test do
  use ExUnit.Case
  doctest Etudes13

  require Logger
  require IEx

  import ExUnit.CaptureIO

  Etudes13.define_symbols

  test "Atomic weight of one atom" do
    assert o == 15.999
  end

  test "Atomic weight of water" do
    water = h * 2 + o
    assert water == 18.015
  end

  test "Atomic weight of sulfuric acid" do
    sulfuric_acid = h * 2 + s + o * 4
    assert sulfuric_acid == 98.072
  end

  test "Atomic weight of salt" do
    salt = na + cl
    assert salt == 58.44
  end

  test "Add durations that don't cause second overflow" do
    duration = Etudes13.add({2,15},{3,12})
    assert duration == {5,27}
  end

  test "Add durations that do cause second overflow" do
    duration = Etudes13.add({2,45},{3,22})
    assert duration == {6,7}
  end

end
