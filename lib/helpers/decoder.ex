defmodule Decoder.Helpers do
  @moduledoc """
  Hosts functions helpful when decoding data.

  """


  @doc """
  Applies `fun` to `x` if x is not `nil`. Useful for preventing code from
  raising and making unnecessary noise.

  iex> import Decoder.Helpers
  ...> "hello" |> nil_friendly(&String.upcase/1)
  "HELLO"

  iex> import Decoder.Helpers
  ...> nil |> nil_friendly(&String.upcase/1)
  nil

  """
  def nil_friendly(nil, _fun), do: nil
  def nil_friendly(x, fun), do: fun.(x)


  @doc """
  Nullifies empty strings.

  iex> import Decoder.Helpers
  ...> empty_as_nil("")
  nil

  """
  def empty_as_nil(""), do: nil
  def empty_as_nil(x), do: x


  @doc """
  Coerces `input` into `true` if it matches as the value supplied as `truthy`,
  false if it matches as `falsy`.

  iex> import Decoder.Helpers
  ...> "Y" |> coerce_as_bool("Y", "N")
  true

  iex> import Decoder.Helpers
  ...> "N" |> coerce_as_bool("Y", "N")
  false

  """
  @spec coerce_as_bool(String.t, String.t, String.t) :: boolean
  def coerce_as_bool(input, truthy, falsy) do
    case input do
      ^truthy -> true
      ^falsy  -> false
    end
  end


  @doc """
  Coerces `input` into `true` if it matches as the value supplied as `truthy`,
  false if it matches anything else.

  iex> import Decoder.Helpers
  ...> "Y" |> coerce_as_bool("Y")
  true

  iex> import Decoder.Helpers
  ...> "chicken" |> coerce_as_bool("Y")
  false

  """
  @spec coerce_as_bool(String.t, String.t, String.t) :: boolean
  def coerce_as_bool(input, truthy) do
    case input do
      ^truthy -> true
      _ -> false
    end
  end


  @doc """
  Coerces `input` into a `float`.

  iex> import Decoder.Helpers
  ...> coerce_as_float("19")
  19.0

  """
  @spec coerce_as_float(String.t) :: float
  def coerce_as_float(input) do
    with {f, ""} <- Float.parse(input) do
      f
    end
  end

end
