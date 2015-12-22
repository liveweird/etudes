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

  test "All phone numbers present" do
    registry = Etudes11.setup("./test/call_data.csv")
    numbers = Etudes11.get_numbers(registry)
    sorted = Enum.sort(numbers)
    assert [ "213-555-0172", "301-555-0433", "415-555-7871", "650-555-3326", "729-555-8855", "838-555-1099", "946-555-9760" ] == sorted
  end

  test "All phone calls for particular phone numbers present" do
    registry = Etudes11.setup("./test/call_data.csv")
    numbers = Etudes11.get_numbers(registry)
    [{_, calls1}] = Etudes11.get_calls(registry, "213-555-0172")
    # Logger.info "Calls: |#{inspect calls1}|."
    assert [%Etudes11.PhoneCall{end_date_time: {{"2013", "03", "10"}, {"09", "03", "49"}}, start_date_time: {{"2013", "03", "10"}, {"09", "00", "59"}}},
            %Etudes11.PhoneCall{end_date_time: {{"2013", "03", "10"}, {"09", "06", "00"}}, start_date_time: {{"2013", "03", "10"}, {"09", "04", "26"}}},
            %Etudes11.PhoneCall{end_date_time: {{"2013", "03", "10"}, {"09", "10", "35"}}, start_date_time: {{"2013", "03", "10"}, {"09", "06", "59"}}}] == calls1
    [{_, calls2}] = Etudes11.get_calls(registry, "415-555-7871")
    # Logger.info "Calls: |#{inspect calls2}|."
    assert [%Etudes11.PhoneCall{end_date_time: {{"2013", "03", "10"}, {"09", "05", "09"}}, start_date_time: {{"2013", "03", "10"}, {"09", "02", "20"}}},
            %Etudes11.PhoneCall{end_date_time: {{"2013", "03", "10"}, {"09", "09", "32"}}, start_date_time: {{"2013", "03", "10"}, {"09", "06", "15"}}}] == calls2
  end

  test "Summary for non-existent number" do
    registry = Etudes11.setup("./test/call_data.csv")
    numbers = Etudes11.summary("111-222-3333")
    assert [{"111-222-3333", 0}] == numbers
  end

  test "Summary for existing number" do
    registry = Etudes11.setup("./test/call_data.csv")
    numbers = Etudes11.summary("415-555-7871")
    assert [{"415-555-7871", 6}] == numbers
  end

  test "Summary for all the numbers"

end
