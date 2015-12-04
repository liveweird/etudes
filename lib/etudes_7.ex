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
    result = File.open(file_name, [:read, :utf8])
    countries = []
    case result do
      { :ok, device } ->
        country = nil
        Enum.each(IO.read(device, :line), fn (line) ->
            atoms = line |> String.split(",") |> String.strip
            country =
              case atoms do
                [ country_name, language ] -> %Country{name: country_name, language: language, cities: []}
                [ city_name, population, latitude, longitude ] -> add_city(country, %City{name: city_name, population: population, latitude: latitude, longitude: longitude})
                _ -> raise RuntimeError, "Wrong file format"
              end
            update_country(countries, country)
          end)
        File.close(device)
      { :error, error_code } -> raise RuntimeError, "Can't read file! #{error_code}"
    end
  end

  @spec add_city(%Country{}, %City{}) :: %Country{}
  defp add_city(country, city) do
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
      nil -> [ country ]
    end
  end

end
