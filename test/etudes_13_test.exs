defmodule Etudes13Test do
  use ExUnit.Case
  doctest Etudes13

  require Logger
  require IEx

  import ExUnit.CaptureIO

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

end
