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

    def handle_call({code}, from, state) do
      # add code to history
      updated_state =
        cond do
          HashSet.member?(state, code) -> state
          true -> HashSet.put(state, code)
        end
      Logger.info "State: |#{inspect updated_state}|."

      # get info
      url = "http://w1.weather.gov/xml/current_obs/" <> code <> ".xml"
      Logger.info "URL: |#{inspect url}|."
      info = :httpc.request(:get, {url |> String.to_char_list, []}, [], [])
      Logger.info "Info: |#{inspect info}|."

      # return
      {:reply, info, updated_state}
    end

    def handle_cast({""}, state) do
      {:noreply, state}
    end

  end

end
