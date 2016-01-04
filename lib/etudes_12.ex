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

    def start_link do
      GenServer.start_link(__MODULE__, :ok, [{:name, __MODULE__}])
    end

    def init(:ok) do
      {:ok, []}
    end

    def handle_call({:login, user_name, server_name}, {pid, reference}, state) do
      found = List.keyfind(state, {user_name, server_name}, 0)
      case found do
        nil -> {:reply, :ok, [{{user_name, server_name}, pid}] ++ state}
        {{^user_name, ^server_name}, _} -> {:reply, {:error, "User already logged in"}, state}
      end
    end

    def handle_call(:logout, {pid, reference}, state) do
      found = List.keyfind(state, pid, 1)
      case found do
        nil -> {:reply, {:error, "User not logged in"}, state}
        {{_, _}, pid} -> {:reply, :ok, List.delete(state, found)}
      end
    end

    def handle_call({:say, text}, from, state) do
    end

    def handle_call(:users, from, state) do
      {:reply, state, state}
    end

    def handle_call({:profile, user_name, server_name}, from, state) do
      found = List.keyfind(state, {user_name, server_name}, 0)
      case found do
        nil -> {:reply, {:error, "Unknown user"}, state}
        {{^user_name, ^server_name}, pid} ->
          profile = GenServer.call(pid, :get_profile)
          {:reply, profile, state}
      end
    end

    def users() do
      GenServer.call(Etudes12.Chatroom, :users)
    end

    def who(user_name, user_node) do
      GenServer.call(Etudes12.Chatroom, {:profile, user_name, user_node})
    end

  end

  defmodule Person do
    use GenServer

    def start_link(chatroom) do
      GenServer.start_link(__MODULE__, chatroom, [])
    end

    def init(chatroom) do
      {:ok, %{:chatroom => chatroom, :props => %{}}}
    end

    def handle_call(:get_chat_node, from, state) do
    end

    def handle_call({:login, user_name}, from, state) do
      response = GenServer.call(Etudes12.Chatroom, {:login, user_name, state[:chatroom]})
      {:reply, response, state}
    end

    def handle_call(:logout, from, state) do
      response = GenServer.call(Etudes12.Chatroom, :logout)
      {:reply, response, state}
    end

    def handle_call({:say, text}, from, state) do
    end

    def handle_call(:get_profile, from, state) do
      {:reply, state[:props], state}
    end

    def handle_call({:set_profile, key, value}, from, state) do
      props = Map.put(state[:props], key, value)
      {:reply, :ok, %{:chatroom => state[:chatroom], :props => props}}
    end

    def get_chat_node() do
    end

    def login(person, user_name) do
      GenServer.call(person, {:login, user_name})
    end

    def logout(person) do
      GenServer.call(person, :logout)
    end

    def say(text) do
    end

    def set_profile(person, key, value) do
      GenServer.call(person, {:set_profile, key, value})
    end

  end

end
