defmodule Etudes12 do
  @moduledoc """
    GenServer!
  """

  require Logger
  require IEx

  defmodule Weather do
    use GenServer

    def start_link(opts \\ []) do
      GenServer.start_link(__MODULE__, :ok, opts)
    end

    def init(:ok) do
      :ok = :inets.start()
      {:ok, HashSet.new}
    end

    defp get_content(xml, element_name) do
      result = Regex.run(~r/<temp_c>([^<]+)<\/temp_c>/, xml |> to_string)
      case result do
        [_all, match] -> {element_name, match}
        nil -> {element_name, nil}
      end
    end

    def handle_call({code}, from, state) do
      # add code to history
      updated_state =
        cond do
          HashSet.member?(state, code) -> state
          true -> HashSet.put(state, code)
        end

      # get info
      url = "http://w1.weather.gov/xml/current_obs/" <> code <> ".xml"
      {:ok, {_, _, content}} = :httpc.request(:get, {url |> String.to_char_list, [{'User-Agent', 'Mozilla/5.0'}]}, [], [])
      temp_c = content |> get_content("temp_c")

      # return
      {:reply, temp_c, updated_state}
    end

    def handle_cast({""}, state) do
      IO.puts "inspect #{state}"
      {:noreply, state}
    end

    def terminate(reason, state) do
      :inets.stop()
      :ok
    end

  end

end
