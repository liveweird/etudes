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
      cached = :ets.lookup(registry, number)
      # Logger.info "Read: |#{inspect cached}|."

      result =
        case cached do
          [{^number, phone_calls}] ->
            :ets.insert(registry, { number, phone_calls ++ [ phone_call ] })
          [] -> :ets.insert(registry, { number, [ phone_call ] })
        end

      # Logger.info "Result: |#{inspect result}|."
    end)
    registry
  end

  @spec parse_date(String.t()) :: tuple()
  defp parse_date(to_be_parsed) do
    matched = Regex.run(~r/^\s*(\d\d\d\d)-(\d\d)-(\d\d)\s*$/, to_be_parsed)
    date_parsed =
      case matched do
        [ _, year, month, day ] -> { String.to_integer(year), String.to_integer(month), String.to_integer(day) }
        _ -> raise ArgumentError, "Date parse error"
      end
    date_parsed
  end

  @spec parse_time(String.t()) :: tuple()
  defp parse_time(to_be_parsed) do
    matched = Regex.run(~r/^\s*(\d\d):(\d\d):(\d\d)\s*$/, to_be_parsed)
    time_parsed =
      case matched do
        [ _, hour, minute, second ] -> { String.to_integer(hour), String.to_integer(minute), String.to_integer(second) }
        _ -> raise ArgumentError, "Time parse error"
      end
    time_parsed
  end

  @doc """
    Get all numbers in the book
  """
  @spec get_numbers(pid()) :: list()
  def get_numbers(registry) do
    numbers = :ets.foldl(fn ({ number, _ }, acc) ->
      [ number ] ++ acc
    end, [], registry)
    # Logger.info "Numbers: |#{inspect numbers}|."
    numbers
  end

  @doc """
    Get calls for particular number
  """
  @spec get_calls(pid(), String.t()) :: list()
  def get_calls(registry, number) do
    :ets.lookup(registry, number)
  end

  @doc """
    Summary of calls length for particular number
  """
  @spec summary(pid(), String.t()) :: list()
  def summary(registry, number) do
    cached = :ets.lookup(registry, number)
    result =
      case cached do
        [{^number, phone_calls}] ->
          calc_duration(phone_calls, 0)
        [] -> 0
      end
    [{number, div(result, 60)}]
  end

  @spec calc_duration(list(), integer) :: integer
  defp calc_duration(phone_calls, duration) do
    case phone_calls do
      [%Etudes11.PhoneCall{end_date_time: end_date_time, start_date_time: start_date_time} | rest] ->
        # Logger.info "Start: |#{inspect start_date_time}|."
        # Logger.info "End: |#{inspect end_date_time}|."
        end_secs = :calendar.datetime_to_gregorian_seconds(end_date_time)
        start_secs = :calendar.datetime_to_gregorian_seconds(start_date_time)
        calc_duration(rest, duration + (end_secs - start_secs))
      [] -> duration
    end
  end

  @doc """
    Summary of calls length for all numbers
  """
  @spec summary(pid()) :: list()
  def summary(registry) do
    numbers = :ets.foldl(fn ({ number, _ }, acc) ->
      partial = summary(registry, number)
      acc ++ partial
    end, [], registry)
    # Logger.info "Numbers: |#{inspect numbers}|."
    numbers
  end

end
