defmodule Etudes13 do
  @moduledoc """
    Macros!
  """

  require Logger
  require IEx

  defmacro define_symbols do
    data = [{:h, 1.008}, {:he, 4.003},
    {:li, 6.94}, {:be, 9.012}, {:b, 10.81}, {:c, 12.011},
    {:n, 14.007}, {:o, 15.999}, {:f, 18.998}, {:ne, 20.178},
    {:na, 22.990}, {:mg, 24.305}, {:al, 26.981}, {:si, 28.085},
    {:p, 30.974}, {:s, 32.06}, {:cl, 35.45}, {:ar, 39.948},
    {:k, 39.098}, {:ca, 40.078}, {:sc, 44.956}, {:ti, 47.867},
    {:v, 50.942}, {:cr, 51.996}, {:mn, 54.938}, {:fe, 55.845}]

    data
      |> Enum.map(fn {name, weight} ->
        quote do
          defp unquote(name)() do
            unquote(weight)
          end
        end
      end)
  end

end
