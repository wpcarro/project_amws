defmodule Spreadsheet.AdCostBySKU do
  @moduledoc """
  This module holds functions related to creating the "Ad Cost By SKU"
  spreadsheet.

  """

  alias Web.Spreadsheet

  @behaviour Spreadsheet


  @fields [
    "start_date",
    "end_date",
    "merchant_name",
    "sku",
    "clicks",
    "impressions",
    "ctr",
    "currency",
    "total_spend",
    "avg_cpc",
  ]


  @spec compile :: Spreadsheet.table
  def compile do
    true
  end
end
