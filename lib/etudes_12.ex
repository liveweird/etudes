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
      GenServer.start_link(__MODULE__, name, [])
    end

    def init(name) do
      {:ok, %{:name => name, :users => []}}
    end

    def handle_call({:login, user_name}, {pid, reference}, state) do
      found = List.keyfind(state[:users], user_name, 0)
      case found do
        nil -> {:reply, {:ok, state[:name]}, %{state | :users => [{user_name, pid}] ++ state[:users]}}
        {^user_name, _} -> {:reply, {:error, "User already logged in"}, state}
      end
    end

    def handle_call(:logout, {pid, reference}, state) do
      found = List.keyfind(state[:users], pid, 1)
      case found do
        nil -> {:reply, {:error, "User not logged in"}, state}
        {_, pid} -> {:reply, :ok, %{state | :users => List.delete(state[:users], found)}}
      end
    end

    def handle_call({:say, text}, {pid, ref}, state) do
      sayer = List.keyfind(state[:users], pid, 1)
      Logger.info "Before output"
      output =
        case sayer do
          {name, pid} ->
            state[:users]
              |> Enum.filter(fn {name1, pid1} -> pid != pid1 end)
              |> Enum.each(fn {name2, pid2} -> GenServer.cast(pid2, {:message, {name, state[:name]}, text}) end)
            :ok
          _ -> {:error, "User not logged in can't say anything"}
        end
      Logger.info "Output = #{output}"
      {:reply, output, state}
    end

    def handle_call(:users, from, state) do
      {:reply, state[:users], state}
    end

    def handle_call({:profile, user_name}, from, state) do
      found = List.keyfind(state[:users], user_name, 0)
      case found do
        nil -> {:reply, {:error, "Unknown user"}, state}
        {^user_name, pid} ->
          profile = GenServer.call(pid, :get_profile)
          {:reply, profile, state}
      end
    end

    def users(chatroom) do
      GenServer.call(chatroom, :users)
    end

    def who(user_name, chatroom) do
      GenServer.call(chatroom, {:profile, user_name})
    end

  end

  defmodule Person do
    use GenServer

    def start_link(name) do
      GenServer.start_link(__MODULE__, name, [])
    end

    def init(name) do
      {:ok, %{:name => name, :chatrooms => [], :props => %{}, :history => []}}
    end

    # def handle_call(:get_chat_node, from, state) do
    #   {:reply, state[:chatroom], state}
    # end

    def handle_call({:login, chatroom}, from, state) do
      response = GenServer.call(chatroom, {:login, state[:name]})
      new_chatrooms =
        case response do
          {:ok, server_name} ->
            [{server_name, chatroom}] ++ state[:chatrooms]
          _ -> state[:chatrooms]
        end
      {:reply, response, %{state | :chatrooms => new_chatrooms}}
    end

    def handle_call({:logout, chatroom}, from, state) do
      response = GenServer.call(chatroom, :logout)
      new_chatrooms =
        case response do
          {:ok, server_name} ->
            List.delete(state[:chatrooms], {server_name, chatroom})
          _ -> state[:chatrooms]
        end
      {:reply, response, %{state | :chatrooms => new_chatrooms}}
    end

    def handle_call({:say, chatroom, text}, {pid, ref}, state) do
      room = List.keyfind(state[:chatrooms], chatroom, 1)
      output =
        case room do
          {chatroom_name, ^chatroom} ->
            history = [{{state[:name], chatroom_name}, text}] ++ state[:history]
            response = GenServer.call(chatroom, {:say, text})
            {:reply, response, %{state | :history => history}}
          nil -> {:reply, {:error, "Can't say in channel you're not logged into"}, state}
        end
      output
    end

    def handle_cast({:message, {user_name, chatroom_name}, text}, state) do
      history = [{{user_name, chatroom_name}, text}] ++ state[:history]
      {:noreply, :ok, %{state | :history => history}}
    end

    def handle_call(:get_profile, from, state) do
      {:reply, state[:props], state}
    end

    def handle_call({:set_profile, key, value}, from, state) do
      props = Map.put(state[:props], key, value)
      {:reply, :ok, %{state | :props => props}}
    end

    def handle_call(:get_history, from, state) do
      {:reply, state[:history], state}
    end

    # def get_chat_node() do
    #   GenServer.call(person, :get_chat_node)
    # end

    def login(person, room) do
      GenServer.call(person, {:login, room})
    end

    def logout(person, room) do
      GenServer.call(person, {:logout, room})
    end

    def say(person, room, text) do
      GenServer.call(person, {:say, room, text})
    end

    def set_profile(person, key, value) do
      GenServer.call(person, {:set_profile, key, value})
    end

    def get_history(person) do
      GenServer.call(person, :get_history)
    end

  end

end
