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

  test "Get empty list of logged users" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, _} = Etudes12.Person.start_link("person1")
    assert [] == Etudes12.Chatroom.users(room1)
  end

  test "Client logs in" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, person1} = Etudes12.Person.start_link("person1")
    assert {:ok, "room1"} == Etudes12.Person.login(person1, room1)
    assert [{"person1", person1}] == Etudes12.Chatroom.users(room1)
  end

  test "Client logs in twice" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, person1} = Etudes12.Person.start_link("person1")
    assert {:ok, "room1"} == Etudes12.Person.login(person1, room1)
    assert {:error, "User already logged in"} == Etudes12.Person.login(person1, room1)
    assert [{"person1", person1}] == Etudes12.Chatroom.users(room1)
  end

  test "Client with the same name tries to log in" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, person1a} = Etudes12.Person.start_link("person1")
    {:ok, person1b} = Etudes12.Person.start_link("person1")
    assert {:ok, "room1"} == Etudes12.Person.login(person1a, room1)
    assert {:error, "User already logged in"} == Etudes12.Person.login(person1b, room1)
    assert [{"person1", person1a}] == Etudes12.Chatroom.users(room1)
  end

  test "Non-logged client tries to log out" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, person1} = Etudes12.Person.start_link("person1")
    assert {:error, "User not logged in"} == Etudes12.Person.logout(person1, room1)
    assert [] == Etudes12.Chatroom.users(room1)
  end

  test "Logged out client tries to log out" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, person1} = Etudes12.Person.start_link("person1")
    assert {:ok, "room1"} == Etudes12.Person.login(person1, room1)
    assert :ok == Etudes12.Person.logout(person1, room1)
    assert [] == Etudes12.Chatroom.users(room1)
    assert {:error, "User not logged in"} == Etudes12.Person.logout(person1, room1)
    assert [] == Etudes12.Chatroom.users(room1)
  end

  test "Client logs out" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, person1} = Etudes12.Person.start_link("person1")
    assert {:ok, "room1"} == Etudes12.Person.login(person1, room1)
    assert [{"person1", person1}] == Etudes12.Chatroom.users(room1)
    assert :ok == Etudes12.Person.logout(person1, room1)
    assert [] == Etudes12.Chatroom.users(room1)
  end

  test "Set profile property" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, person1} = Etudes12.Person.start_link("person1")
    assert {:ok, "room1"} == Etudes12.Person.login(person1, room1)
    Etudes12.Person.set_profile(person1, "ABC","DEF")
    assert %{"ABC" => "DEF"} == Etudes12.Chatroom.who("person1", room1)
  end

  test "Set property twice" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, person1} = Etudes12.Person.start_link("person1")
    assert {:ok, "room1"} == Etudes12.Person.login(person1, room1)
    Etudes12.Person.set_profile(person1, "ABC","DEF")
    Etudes12.Person.set_profile(person1, "ABC","GHI")
    assert %{"ABC" => "GHI"} == Etudes12.Chatroom.who("person1", room1)
  end

  test "Inspecting a person" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, person1} = Etudes12.Person.start_link("person1")
    assert {:ok, "room1"} == Etudes12.Person.login(person1, room1)
    assert %{} == Etudes12.Chatroom.who("person1", room1)
  end

  test "Inspecting a non-logged person" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, _} = Etudes12.Person.start_link("person1")
    assert {:error, "Unknown user"} == Etudes12.Chatroom.who("person1", room1)
  end

  test "Inspecting a non-existent person" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, person1} = Etudes12.Person.start_link("person1")
    assert {:ok, "room1"} == Etudes12.Person.login(person1, room1)
    assert {:error, "Unknown user"} == Etudes12.Chatroom.who("person2", room1)
  end

  test "Person says something to himself" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, person1} = Etudes12.Person.start_link("person1")
    assert {:ok, "room1"} == Etudes12.Person.login(person1, room1)
    Etudes12.Person.say(person1, room1, "Somethin'")
    assert [{{"person1", "room1"}, "Somethin'"}] == Etudes12.Person.get_history(person1)
  end

  test "Person says something (in company)" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, person1} = Etudes12.Person.start_link("person1")
    {:ok, person2} = Etudes12.Person.start_link("person2")
    assert {:ok, "room1"} == Etudes12.Person.login(person1, room1)
    assert {:ok, "room1"} == Etudes12.Person.login(person2, room1)
    Etudes12.Person.say(person1, room1, "Somethin'")
    assert [{{person1, room1}, "Somethin'"}] == Etudes12.Person.get_history(person1)
    assert [{{person1, room1}, "Somethin'"}] == Etudes12.Person.get_history(person2)
  end

  test "Messages come in sequence" do
    {:ok, room1} = Etudes12.Chatroom.start_link("room1")
    {:ok, person1} = Etudes12.Person.start_link("person1")
    {:ok, person2} = Etudes12.Person.start_link("person2")
    assert {:ok, "room1"} == Etudes12.Person.login(person1, room1)
    assert {:ok, "room1"} == Etudes12.Person.login(person2, room1)
    Etudes12.Person.say(person2, room1, "Somethin'")
    assert [{{person2, room1}, "Somethin'"}, {{person1, room1}, "... different"}] == Etudes12.Person.get_history(person1)
    Etudes12.Person.say(person1, room1, "... different")
    assert [{{person2, room1}, "Somethin'"}, {{person1, room1}, "... different"}] == Etudes12.Person.get_history(person2)
  end

  test "Person tries to say something while not logged in"

  test "Person tries to say something after logging out"

  test "Person writes something to two different chatrooms"

end
