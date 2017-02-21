defmodule Map.Extra do
  @moduledoc false

  @type t :: map


  @doc """
  Adds values from `b` into `a` by concatenated them. This assumes that values
  `a` are initialized with lists already.

  iex> Map.Extra.merge_with_concat(%{age: [21]}, %{age: 42})
  %{age: [42, 21]}

  """
  @spec merge_with_concat(t, t) :: t
  def merge_with_concat(a, b) when is_map(a) and is_map(b) do
    assert_shared_keys!(a, b)

    Enum.reduce(b, a, fn {key, value}, a ->
      Map.update!(a, key, fn list -> [value | list] end)
    end)
    |> IO.inspect(label: "result")
  end


  @doc """
  Asserts maps `a` and `b` have the same keys.

  """
  @spec assert_shared_keys!(t, t) :: :ok | no_return
  def assert_shared_keys!(a, b) when is_map(a) and is_map(b) do
    set_a =
      a |> Map.keys() |> MapSet.new()

    set_b =
      b |> Map.keys() |> MapSet.new()

    case MapSet.equal?(set_a, set_b) do
      true -> :ok
      false -> raise("Maps do not share the same fields.")
    end
  end


end
