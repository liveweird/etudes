defmodule Etudes12Test do
  use ExUnit.Case, async: true
  doctest Etudes12

  require Logger
  require IEx

  import ExUnit.CaptureIO

  test "Get weather info for existing location" do
    Etudes12.WeatherSupervisor.start_link
    temp_c = Etudes12.ask_weather({"KSJC"})
    # Logger.info "Response: |#{inspect temp_c}|."
    assert tuple_size(temp_c) == 2
    assert elem(temp_c, 0) == "temp_c"
    assert {:error} != Float.parse(elem(temp_c,1))
    Logger.info "Supervisor: |#{inspect Supervisor.count_children(Etudes12.WeatherSupervisor)}|."
    Supervisor.terminate_child(Etudes12.WeatherSupervisor, Etudes12.Weather)
    Logger.info "Supervisor: |#{inspect Supervisor.count_children(Etudes12.WeatherSupervisor)}|."
  end

  test "Try to get weather for non-existent location" do
    Etudes12.WeatherSupervisor.start_link
    temp_c = Etudes12.ask_weather({"WXYZ"})
    # Logger.info "Response: |#{inspect temp_c}|."
    assert tuple_size(temp_c) == 2
    assert elem(temp_c, 0) == "temp_c"
    assert elem(temp_c, 1) == nil
    Logger.info "Supervisor: |#{inspect Supervisor.count_children(Etudes12.WeatherSupervisor)}|."
    Supervisor.terminate_child(Etudes12.WeatherSupervisor, Etudes12.Weather)
    Logger.info "Supervisor: |#{inspect Supervisor.count_children(Etudes12.WeatherSupervisor)}|."
  end

  test "History of visited sites works fine" do
    Etudes12.WeatherSupervisor.start_link
    assert capture_io(fn ->
      Etudes12.ask_weather({"KSJC"})
      Etudes12.ask_weather({"KITH"})
      Etudes12.ask_history()
    end) == "KSJC\nKITH"
    # Logger.info "Supervisor: |#{inspect Supervisor.count_children(Etudes12.WeatherSupervisor)}|."
    # Supervisor.terminate_child(Etudes12.WeatherSupervisor, Etudes12.Weather)
    # Logger.info "Supervisor: |#{inspect Supervisor.count_children(Etudes12.WeatherSupervisor)}|."
  end

end
