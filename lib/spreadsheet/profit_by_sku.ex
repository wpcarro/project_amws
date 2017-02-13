defmodule Spreadsheet.ProfitBySKU do
  @moduledoc """
  This module holds functions related to creating the "Profit By SKU"
  spreadsheet.

  """

  @behavior GenSpreadsheet


  @fields [
    "sku",
    "product_name",
    "quantity",
    "coupon_qty",
    "price / unit",
    "cogs / unit",
    "sales",
    "cogs",
    "ship_cred",
    "rebates",
    "sales_tax",
    "selling_fees",
    "fba_fees",
    "trans_fees",
    "gross_margin",
    "coupon_cost",
    "advertising",
    "refunds",
    "gift_wrap",
    "other",
    "net_margin",
  ]


  @spec compile :: Spreadsheet.table
  def compile do
    true
  end
end
