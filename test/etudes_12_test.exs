defmodule Etudes12Test do
  use ExUnit.Case, async: true
  doctest Etudes12

  require Logger
  require IEx

  setup do
    {:ok, history} = Etudes12.Weather.start_link
    {:ok, history: history}
  end

  test "Get weather info for existing location", %{history: history} do
    info = GenServer.call(history, {"KSJC"})
    Logger.info "Info: |#{inspect info}|."
  end

  test "Try to get weather for non-existent location"

end
