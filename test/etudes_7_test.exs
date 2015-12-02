defmodule Etudes7Test do
  use ExUnit.Case
  doctest Etudes7

  require Logger
  require IEx

  test "collection is not empty" do
    assert (Etudes7.make_geo_list("geography.csv") |> Enum.count) == 4
  end

  test "countries are proper" do
    countries = Etudes7.make_geo_list("geography.csv") |> Enum.map(fn (elem) -> elem.name end) |> Enum.uniq |> Enum.sort
    zipped = Enum.zip(countries, [ "Germany", "Peru", "South Korea", "Spain" ])
    assert Enum.count(zipped) == 4
    assert Enum.all?(zipped, fn (el) -> elem(el, 0) == elem(el, 1) end) == true
  end

  test "languages are proper" do
    countries = Etudes7.make_geo_list("geography.csv")
    map = %{:Germany => "German", :Peru => "Spanish", :"South Korea" => "Korean", :Spain => "Spanish"}
    assert Enum.all?(countries, fn (country) ->
      name = country[:name]
      lang = country[:language]
      expected = map[name]
      lang == expected
    end) == true
  end

end
