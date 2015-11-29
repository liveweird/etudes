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
  @spec get_number(list(), list()) :: list()
  def get_number([], []) do
    []
  end

  @spec get_number(list(), list()) :: list()
  def get_number(prompts, [ x | xs ]) do
    case prompts do
      [ prompt | rest ] ->
        variable = get_part_number(prompt, x)
        temp =
        case variable do
          {:ok, a} -> [ a | get_number(rest, xs) ]
          {:error, _} -> get_number(prompts, xs)
        end
        # Logger.info "get_number1(list): |#{inspect(temp)}|."
        temp
      prompt ->
        variable = get_part_number(prompt, x)
        temp =
        case variable do
          {:ok, a} -> [ a ]
          {:error, _} -> get_number(prompt, xs)
        end
        # Logger.info "get_number2(list): |#{inspect(temp)}|."
        temp
    end
  end

  @spec get_part_number(String.t, (... -> any) | none) :: integer()
  def get_part_number(prompt, func \\ fn(_) -> IO.gets end) do
    result =
    try do
      variable = func.(prompt) |> String.strip |> Integer.parse |> elem(0)
      {:ok, variable}
    rescue
      err in ArgumentError -> {:error, err}
    end
    # Logger.info "get_particular_number(item): |#{inspect(result)}|."
    result
  end

  @doc """
    return two dimensions from command prompt
  """
  @spec get_dimensions(String.t, String.t, list()) :: tuple()
  def get_dimensions(prompt1, prompt2, [ x | xs ]) do
    get_number([ prompt1 | prompt2 ], [ x | xs ])
  end

  @doc """
    calculate the area
  """
  @spec calculate(atom(),integer(),integer()) :: number()
  def calculate(shape, dim1, dim2) do
    Etudes4.area({shape, dim1, dim2})
  end

  @doc """
    end to end

    iex> Etudes5.area(fn(_) -> "t" end, fn(_) -> "4" end, fn(_) -> "5" end)
    10.0

    iex> Etudes5.area(fn(_) -> "r" end, fn(_) -> "4" end, fn(_) -> "5" end)
    20

    iex> Etudes5.area(fn(_) -> "e" end, fn(_) -> "4" end, fn(_) -> "5" end)
    62.83185307179586
  """
  @spec area((... -> String.t) | none, (... -> String.t) | none, (... -> String.t) | none) :: integer()
  def area(func1 \\ fn(a) -> IO.gets(a) end, func2 \\ fn(b) -> IO.gets(b) end, func3 \\ fn(c) -> IO.gets(c) end) do
    shape = Etudes5.char_to_shape(func1.("aaa"))
    dims = Etudes5.get_dimensions("bbb", "ccc", [ func2, func3 ])
    Etudes5.calculate(shape, Enum.at(dims, 0), Enum.at(dims, 1))
  end

end
