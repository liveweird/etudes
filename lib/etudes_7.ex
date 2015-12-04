defmodule Etudes7 do
  @moduledoc """
    Structures
  """

  require Logger
  require IEx

  defmodule Country do
    defstruct name: "", language: "", cities: []
  end

  defmodule City do
    defstruct name: "", population: 0, latitude: 0, longitude: 0
  end

  @doc """
    Read geo data from the file
  """
  @spec make_geo_list(String.t()) :: list()
  def make_geo_list(file_name) do
    countries = []
    country = nil
    File.stream!(file_name, [:read, :utf8], :line) |>
    Enum.each(fn (line) ->
      atoms = line |> to_string |> String.split(",") |> Enum.map(&String.strip(&1))
      country =
        case atoms do
          [ country_name, language ] -> %Country{name: country_name, language: language, cities: []}
          [ city_name, population, latitude, longitude ] -> add_city(country, %City{name: city_name, population: population, latitude: latitude, longitude: longitude})
          _ -> raise RuntimeError, "Wrong file format"
        end
      countries = update_country(countries, country)
    end)
    countries
  end

  @spec add_city(%Country{}, %City{}) :: %Country{}
  defp add_city(country, city) do
    Logger.info "Country: |#{inspect country}|."
    Logger.info "City: |#{inspect city}|."
    if country == nil do
      raise RuntimeError, "City can't exist w/o country!"
    end

    %{country | cities: [ city | country.cities ] }
  end

  @spec update_country(list(), %Country{}) :: list()
  defp update_country(countries, country) do
    case countries do
      [ head | tail ] ->
        if head.name == country.name do
          [ country | tail ]
        else
          [ head | update_country(tail, country) ]
        end
      [] -> [ country ]
    end
  end

end
