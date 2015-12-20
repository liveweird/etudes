defmodule Etudes11 do
  @moduledoc """
    Chapter #11 - ETS
  """

  require Logger
  require IEx

  defmodule PhoneCall do
    defstruct start_date: "1900-01-01", start_time: "00:00:00", end_date: "1900-01-01", end_time: "00:00:00"
  end

  @doc """
    Read phone call database into malleable format
  """
  @spec setup(String.t()) :: atom()
  def setup(file_name) do
    :ets.new(:phone_call_registry, [:set, :protected, :named_table])
    File.stream!(file_name, [:read, :utf8], :line) |>
    Enum.each(fn (line) ->
      atoms = line |> to_string |> String.split(",") |> Enum.map(&String.strip(&1))
      [ number, start_date, start_time, end_date, end_time ] = atoms
      temp_calls = :ets.lookup(:phone_call_registry, number)
      :ets.insert(:phone_call_registry, temp_calls ++ [ %PhoneCall{ start_date: start_date, start_time: start_time, end_date: end_date, end_time: end_time } ])
    end)
    :phone_call_registry
  end

  @doc """
    Get all numbers in the book
  """
  @spec get_numbers() :: list()
  def get_numbers do
  end

end
