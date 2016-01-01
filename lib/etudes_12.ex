defmodule Etudes12 do
  @moduledoc """
    GenServer!
  """

  require Logger
  require IEx

  def ask_weather(code) do
    GenServer.call({:global, Etudes12.Weather}, code)
  end

  def ask_history do
    GenServer.call({:global, Etudes12.Weather}, {""})
    |> Enum.each(&(IO.puts &1))
  end

  defmodule WeatherSupervisor do
    use Supervisor

    def start_link do
      Supervisor.start_link(__MODULE__, [], [{:name, {:global, __MODULE__}}])
    end

    def init([]) do
      :ok = :inets.start()
      children = [
        worker(Etudes12.Weather, [], [])
      ]
      supervise(children, [
        {:strategy, :one_for_one},
        {:max_restarts, 1},
        {:max_seconds, 5}
      ])
    end

    def tidy_up do
      :inets.stop()
    end

  end

  defmodule Weather do
    use GenServer

    def start_link do
      GenServer.start_link(__MODULE__, :ok, [{:name, {:global, __MODULE__}}])
    end

    def init(:ok) do
      # Logger.info "Initializing GenServer."
      {:ok, HashSet.new}
    end

    defp get_content(xml, element_name) do
      result = Regex.run(~r/<temp_c>([^<]+)<\/temp_c>/, xml |> to_string)
      case result do
        [_all, match] -> {element_name, match}
        nil -> {element_name, nil}
      end
    end

    def handle_call({""}, from, state) do
      output =
        state
        |> Set.to_list
      {:reply, output, state}
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

    def handle_call(:stop, from, state) do
      # Logger.info "Received stop command."
      {:stop, :normal, state}
    end

    def terminate(reason, state) do
      # Logger.info "Terminating GenServer."
      :ok
    end

  end

  defmodule Chatroom do
    use GenServer

    def start_link(name) do
      GenServer.start_link(__MODULE__, :ok, [{:name, {:global, name}}])
    end

    def init(:ok) do
    end

    def handle_call({:login, user_name, server_name}, from, state) do
    end

    def handle_call(:logout, from, state) do
    end

    def handle_call({:say, text}, from, state) do
    end

    def handle_call(:users, from, state) do
    end

    def handle_call({:profile, person, server_name}, from, state) do
    end

  end

  defmodule Person do
    use GenServer

    def start_link do
      GenServer.start_link(__MODULE__, :ok, [{:name, {:global, name}}])
    end

    def init(:ok) do
    end

    def handle_call(:get_chat_node, from, state) do
    end

    def handle_call({:login, user_name}, from, state) do
    end

    def handle_call(:logout, from, state) do
    end

    def handle_call({:say, text}, from, state) do
    end

    def handle_call(:get_profile, from, state) do
    end

    def handle_call({:set_profile, key, value}, from, state) do
    end

    def get_chat_node() do
    end

    def login(user_name) do
    end

    def logout() do
    end

    def say(text) do
    end

    def users() do
    end

    def who(user_name, user_node) do
    end

    def set_profile(key, value) do
    end

  end

end
