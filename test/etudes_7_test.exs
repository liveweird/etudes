defmodule Etudes7Test do
  use ExUnit.Case
  doctest Etudes7

  require Logger
  require IEx

  test "collection is not empty" do
    assert (Etudes7.make_geo_list("./test/geography.csv") |> Enum.count) == 4
  end

  test "countries are proper" do
    countries = Etudes7.make_geo_list("./test/geography.csv") |> Enum.map(fn (elem) -> elem.name end) |> Enum.uniq |> Enum.sort
    zipped = Enum.zip(countries, [ "Germany", "Peru", "South Korea", "Spain" ])
    assert Enum.count(zipped) == 4
    assert Enum.all?(zipped, fn (el) -> elem(el, 0) == elem(el, 1) end) == true
  end

  test "languages are proper" do
    countries = Etudes7.make_geo_list("./test/geography.csv")
    expected_map = %{"Germany" => "German", "Peru" => "Spanish", "South Korea" => "Korean", "Spain" => "Spanish"}
    assert Enum.all?(countries, fn (country) ->
      name = country.name
      lang = country.language
      expected = expected_map |> Map.fetch!(name)
      lang == expected
    end) == true
  end

  test "there are 3 cities in Germany: Hamburg, Frankfurt & Dresden" do
    countries = Etudes7.make_geo_list("./test/geography.csv")
    names = [ "Dresden", "Frankfurt am Main", "Hamburg" ]
    germany = countries |> Enum.find(fn (country) -> country.name == "Germany" end)
    cities = germany.cities |> Enum.map(fn (elem) -> elem.name end) |> Enum.uniq |> Enum.sort
    zipped = Enum.zip(cities, names)
    # Logger.info "cities: |#{inspect zipped}|."
    assert Enum.count(zipped) == 3
    assert Enum.all?(zipped, fn (el) -> elem(el, 0) == elem(el, 1) end) == true
  end

  test "Granada's population is 234325" do
    countries = Etudes7.make_geo_list("./test/geography.csv")
    spain = countries |> Enum.find(fn (country) -> country.name == "Spain" end)
    granada = spain.cities |> Enum.find(fn (city) -> city.name == "Granada" end)
    assert elem(Integer.parse(granada.population), 0) == 234325
  end

  test "Daegu's latitude is 35.87028" do
    countries = Etudes7.make_geo_list("./test/geography.csv")
    korea = countries |> Enum.find(fn (country) -> country.name == "South Korea" end)
    daegu = korea.cities |> Enum.find(fn (city) -> city.name == "Daegu" end)
    assert daegu.latitude == "35.87028"
  end

  test "Lima's longitude is -77.02824" do
    countries = Etudes7.make_geo_list("./test/geography.csv")
    peru = countries |> Enum.find(fn (country) -> country.name == "Peru" end)
    lima = peru.cities |> Enum.find(fn (city) -> city.name == "Lima" end)
    assert lima.longitude == "-77.02824"
  end

  test "Valencia is not in Spain" do
    countries = Etudes7.make_geo_list("./test/geography.csv")
    spain = countries |> Enum.find(fn (country) -> country.name == "Spain" end)
    valencia = spain.cities |> Enum.find(fn (city) -> city.name == "Valencia" end)
    assert valencia == nil
  end

  test "Total population - polish" do
    countries = Etudes7.make_geo_list("./test/geography.csv")
    assert Etudes7.total_population(countries, "Polish") == 0
  end

  test "Total population - korean" do
    countries = Etudes7.make_geo_list("./test/geography.csv")
    assert Etudes7.total_population(countries, "Korean") == (10349312 + 3678555 + 2566540)
  end

  test "Total population - spanish" do
    countries = Etudes7.make_geo_list("./test/geography.csv")
    assert Etudes7.total_population(countries, "Spanish") == (3255944 + 234325 + 1621537 + 7737002 + 312140 + 841130)
  end

  test "Good city is good" do
    good = %Etudes7.City{name: "Hamburg", population: 1739117, latitude: 53.57532, longitude: 10.01534}
    assert Etudes7.Valid.valid?(good) == true
  end

  test "Bad city is bad" do
    bad = %Etudes7.City{name: "Nowhere", population: -1000, latitude: 37.1234, longitude: -12.457}
    assert Etudes7.Valid.valid?(bad) == false
  end

end
