defmodule Etudes6Test do
  use ExUnit.Case
  doctest Etudes6

  require Logger
  require IEx

  test "minimum of empty list is empty" do
      assert_raise ArgumentError, fn -> Etudes6.minimum([]) end
  end

  test "minimum of sole value is this value" do
    assert Etudes6.minimum([5]) == 5
  end

  test "minimum of non-empty list is proper" do
    assert Etudes6.minimum([7,5,6]) == 5
  end

  test "minimum of equal values is proper" do
    assert Etudes6.minimum([7,6,8,6]) == 6
  end

  test "maximum of empty list is empty" do
    assert_raise ArgumentError, fn -> Etudes6.maximum([]) end
  end

  test "maximum of sole value is this value" do
    assert Etudes6.maximum([5]) == 5
  end

  test "maximum of non-empty list is proper" do
    assert Etudes6.maximum([7,8,6]) == 8
  end

  test "maximum of equal values is proper" do
    assert Etudes6.maximum([7,8,6,8]) == 8
  end

  test "range of empty list is empty" do
    assert_raise ArgumentError, fn -> Etudes6.range([]) end
  end

  test "range of sole value is this value twice" do
    assert Etudes6.range([5]) == [5,5]
  end

  test "range of pair is proper" do
    assert Etudes6.range([8,5]) == [5,8]
  end

  test "range of equal pair is proper" do
    assert Etudes6.range([8,8]) == [8,8]
  end

  test "range of non-empty list is proper" do
    assert Etudes6.range([3,8,5,8,7,6]) == [3,8]
  end

  test "range of equal values is proper" do
    assert Etudes6.range([5,5,5]) == [5,5]
  end

end
