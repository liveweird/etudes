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
  @spec get_number(String.t, list()) :: integer()
  def get_number(prompt, [ x | xs ]) do
    variable = get_number(prompt, x)
    case variable do
      {:ok, a} -> a
      {:error, _} -> get_number(prompt, xs)
    end
  end

  @spec get_number(String.t, (... -> any) | none) :: integer()
  def get_number(prompt, func \\ [ fn -> IO.gets end ]) do
    result =
    try do
      variable = func.() |> String.strip |> Integer.parse |> elem(0)
      {:ok, variable}
    rescue
      err in ArgumentError -> {:error, err}
    end
    result
  end

  @doc """
    return two dimensions from command prompt
  """
  @spec get_dimensions(String.t,String.t) :: tuple()
  def get_dimensions(prompt1, prompt2) do
    {-1, -1}
  end

  @doc """
    calculate the area
  """
  @spec calculate(atom(),integer(),integer()) :: number()
  def calculate(shape, dim1, dim2) do
    -1
  end

end
