defmodule Etudes5 do
  @moduledoc """
    Etudes from chapter #5
  """

  require Logger
  require IEx

  @doc """
    character to atom representing shape
  """
  @spec char_to_shape(String.t) :: atom()
  def char_to_shape(char) do
    newChar = char |> String.first |> String.upcase
    # Logger.info "After transformation: [#{newChar}]."
    case newChar do
      "T" -> :triangle
      "E" -> :ellipse
      "R" -> :rectangle
      _ -> :unknown
    end
  end

  @doc """
    return number from user input
  """
  @spec get_number(String.t, integer(), list()) :: integer()
  def get_number(prompt, cnt, [ x | xs ]) do
    cond do
      cnt <= 0 -> []
      true ->
        variable = get_number(prompt, cnt, x)
        temp =
        case variable do
          {:ok, a} -> [ a | get_number(prompt, cnt - 1, xs) ]
          {:error, _} -> get_number(prompt, cnt, xs)
        end
    end
  end

  @spec get_number(String.t, integer(), (... -> any) | none) :: integer()
  def get_number(prompt, cnt \\ 1, func \\ [ fn(_) -> IO.gets end ]) do
    cond do
      cnt <= 0 -> []
      true ->
        result =
        try do
          variable = func.(prompt) |> String.strip |> Integer.parse |> elem(0)
          {:ok, variable}
        rescue
          err in ArgumentError -> {:error, err}
        end
        result
    end
  end

  @doc """
    return two dimensions from command prompt
  """
  @spec get_dimensions(String.t, String.t, list()) :: tuple()
  def get_dimensions(prompt1, prompt2, [ x | xs ]) do
    get_number(prompt1, 2, [x | xs])
  end

  @spec get_dimensions(String.t, String.t, (... -> any) | none) :: tuple()
  def get_dimensions(prompt1, prompt2, func \\ [ fn -> IO.gets end ]) do
    get_number(prompt1, 2, func)
  end

  @doc """
    calculate the area
  """
  @spec calculate(atom(),integer(),integer()) :: number()
  def calculate(shape, dim1, dim2) do
    -1
  end

end
