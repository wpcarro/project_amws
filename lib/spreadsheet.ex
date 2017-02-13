defmodule Web.Spreadsheet do
  @moduledoc """
  Behaviour module for creating spreadsheets.

  """

  @typep field :: atom
  @typep value :: any
  @type table :: %{field => [value]}


  @callback compile() :: table

end
