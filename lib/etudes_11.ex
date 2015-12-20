defmodule Etudes11 do
  @moduledoc """
    Chapter #11 - ETS
  """

  require Logger
  require IEx

  defmodule PhoneCall do
    defstruct start_date_time: {{1900,01,01}, {00,00,00}}, end_date_time: {{1900,01,01}, {00,00,00}}
  end

  @doc """
    Read phone call database into malleable format
  """
  @spec setup(String.t()) :: pid()
  def setup(file_name) do
    registry = :ets.new(:phone_call_registry, [:set, :protected])
    File.stream!(file_name, [:read, :utf8], :line) |>
    Enum.each(fn (line) ->
      atoms = line |> to_string |> String.split(",") |> Enum.map(&String.strip(&1))
      [ number, start_date, start_time, end_date, end_time ] = atoms

      start_date_parsed = parse_date(start_date)
      start_time_parsed = parse_time(start_time)
      end_date_parsed = parse_date(end_date)
      end_time_parsed = parse_time(end_time)

      phone_call = %PhoneCall{ start_date_time: { start_date_parsed, start_time_parsed }, end_date_time: { end_date_parsed, end_time_parsed }}
      temp_calls = :ets.lookup(registry, number)
      :ets.insert(registry, temp_calls ++ [ phone_call ])
    end)
    registry
  end

  @spec parse_date(String.t()) :: tuple()
  defp parse_date(to_be_parsed) do
    matched = Regex.run(~r/^\s*(\d\d\d\d)-(\d\d)-(\d\d)\s*$/, to_be_parsed)
    # Logger.info "Date to be parsed: |#{inspect matched}|."
    date_parsed =
      case matched do
        [ _, year, month, day ] -> { year, month, day }
        _ -> raise ArgumentError, "Date parse error"
      end
    date_parsed
  end

  @spec parse_time(String.t()) :: tuple()
  defp parse_time(to_be_parsed) do
    matched = Regex.run(~r/^\s*(\d\d):(\d\d):(\d\d)\s*$/, to_be_parsed)
    time_parsed =
      case matched do
        [ _, hour, minute, second ] -> { hour, minute, second }
        _ -> raise ArgumentError, "Time parse error"
      end
    time_parsed
  end

  @doc """
    Get all numbers in the book
  """
  @spec get_numbers(pid()) :: list()
  def get_numbers(registry) do
    -1
  end

end
