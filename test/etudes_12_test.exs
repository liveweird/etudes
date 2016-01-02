defmodule Etudes12Test do
  use ExUnit.Case, async: true
  doctest Etudes12

  require Logger
  require IEx

  import ExUnit.CaptureIO

  test "Get weather info for existing location" do
    {:ok, visor} = Etudes12.WeatherSupervisor.start_link
    temp_c = Etudes12.ask_weather({"KSJC"})
    # Logger.info "Response: |#{inspect temp_c}|."
    assert tuple_size(temp_c) == 2
    assert elem(temp_c, 0) == "temp_c"
    assert {:error} != Float.parse(elem(temp_c,1))
    Etudes12.WeatherSupervisor.tidy_up
    Process.unlink(visor)
    Process.exit(visor, :kill)
  end

  test "Try to get weather for non-existent location" do
    {:ok, visor} = Etudes12.WeatherSupervisor.start_link
    temp_c = Etudes12.ask_weather({"WXYZ"})
    # Logger.info "Response: |#{inspect temp_c}|."
    assert tuple_size(temp_c) == 2
    assert elem(temp_c, 0) == "temp_c"
    assert elem(temp_c, 1) == nil
    Etudes12.WeatherSupervisor.tidy_up
    Process.unlink(visor)
    Process.exit(visor, :kill)
  end

  test "History of visited sites works fine" do
    {:ok, visor} = Etudes12.WeatherSupervisor.start_link
    assert capture_io(fn ->
      Etudes12.ask_weather({"KSJC"})
      Etudes12.ask_weather({"KITH"})
      Etudes12.ask_history()
    end) == "KITH\nKSJC\n"
    Etudes12.WeatherSupervisor.tidy_up
    Process.unlink(visor)
    Process.exit(visor, :kill)
  end

  test "Client logs in" do
    {:ok, room} = Etudes12.Chatroom.start_link
    {:ok, person} = Etudes12.Person.start_link(room)
    assert :ok == Etudes12.Person.login("Steve")
    assert [{{"Steve", room}, person}] == Etudes12.Chatroom.users
  end

  test "Client logs in twice" do
    {:ok, room} = Etudes12.Chatroom.start_link
    {:ok, person} = Etudes12.Person.start_link(room)
    assert :ok == Etudes12.Person.login("Steve")
    assert {:error, "User already logged in"} == Etudes12.Person.login("Steve")
    assert [{{"Steve", room}, person}] == Etudes12.Chatroom.users
  end

  test "Client with the same name tries to log in"

  test "Non-logged client tries to log out"

  test "Logged out client tries to log out"

  test "Client logs out" do
    {:ok, room} = Etudes12.Chatroom.start_link("room1")
    Person.start_link(room)
    Person.login("Steve")
    Person.logout
  end

  test "Set profile property"

  test "Set property twice"

  test "Person says something"

  test "Person tries to say something while not logged in"

  test "Person tries to say something after logging out"

  test "Get empty list of logged users"

  test "Get non-empty list of logged users"

  test "Inspecting a person"

  test "Inspecting a person with a changed profile"

  test "Inspecting a non-existent person"

end
