defmodule Etudes11Test do
  use ExUnit.Case
  doctest Etudes11

  require Logger
  require IEx

  test "Input file properly read" do
    registry = Etudes11.setup("./test/call_data.csv")
    numbers = Etudes11.get_numbers(registry)
    assert Enum.count(numbers) == 7
  end

  test "All phone numbers present"

  test "All phone calls for particular phone numbers present"

end
