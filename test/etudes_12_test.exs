defmodule Etudes12Test do
  use ExUnit.Case, async: true
  doctest Etudes12

  require Logger
  require IEx

  import ExUnit.CaptureIO

  setup context do
    {:ok, history} = Etudes12.Weather.start_link
    {:ok, history: history}
  end

  teardown context do
    Process.exit(context[:history], :shutdown)
  end

  test "Get weather info for existing location", %{history: history} do
    temp_c = GenServer.call(history, {"KSJC"})
    # Logger.info "Response: |#{inspect temp_c}|."
    assert tuple_size(temp_c) == 2
    assert elem(temp_c, 0) == "temp_c"
    assert {:error} != Float.parse(elem(temp_c,1))
  end

  test "Try to get weather for non-existent location", %{history: history} do
    temp_c = GenServer.call(history, {"WXYZ"})
    Logger.info "Response: |#{inspect temp_c}|."
    assert tuple_size(temp_c) == 2
    assert elem(temp_c, 0) == "temp_c"
    assert elem(temp_c, 1) == nil
  end

  test "History of visited sites works fine", %{history: history} do
    assert capture_io(fn ->
      GenServer.call(history, {"KSJC"})
      GenServer.call(history, {"KITH"})
      GenServer.cast(history, {""})
    end) == "%{\"KSJC\", \"KITH\"}"
  end

end
