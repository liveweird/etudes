defmodule Etudes6 do
  @moduledoc """
    Chapter #6
  """

  require Logger
  require IEx

  @doc """
    minimum from the give list of values
  """
  @spec minimum(list()) :: number()
  def minimum(values) do
    case values do
      [a|rest] -> minimum_with_intermediate(rest, a)
      _ -> raise ArgumentError, message: "List is empty"
    end
  end

  @spec minimum_with_intermediate(list(), number()) :: number()
  defp minimum_with_intermediate(values, interm) do
    case values do
      [a|rest] when a > interm -> minimum_with_intermediate(rest, interm)
      [a|rest] -> minimum_with_intermediate(rest, a)
      _ -> interm
    end
  end

  @doc """
    maximum from the give list of values
  """
  @spec maximum(list()) :: number()
  def maximum(values) do
    case values do
      [a|rest] -> maximum_with_intermediate(rest, a)
      _ -> raise ArgumentError, message: "List is empty"
    end
  end

  @spec maximum_with_intermediate(list(), number()) :: number()
  defp maximum_with_intermediate(values, interm) do
    case values do
      [a|rest] when a < interm -> maximum_with_intermediate(rest, interm)
      [a|rest] -> maximum_with_intermediate(rest, a)
      _ -> interm
    end
  end

  @doc """
    range (min, max) from the give list of values
  """
  @spec range(list()) :: list()
  def range(values) do
    [minimum(values),maximum(values)]
  end


end
