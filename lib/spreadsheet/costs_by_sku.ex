defmodule Spreadsheet.CostsBySKU do
  @moduledoc """
  This module holds functions related to creating the "Costs By SKU"
  spreadsheet.

  """

  alias Web.Spreadsheet

  @behaviour Spreadsheet


  @fields [
    "sku",
    "product_name",
    "cost_per_unit",
  ]


  @spec compile :: Spreadsheet.table
  def compile do
    true
  end
end
