defmodule Spreadsheet.Orders do
  @moduledoc """
  This module holds functions related to creating the "Orders"
  spreadsheet.

  """

  alias Web.Spreadsheet

  @behaviour Spreadsheet


  @fields [
    "datetime",
    "settlement_id",
    "type",
    "order_id",
    "sku",
    "description",
    "quantity",
    "marketplace",
    "fulfillment",
    "order_city",
    "order_state",
    "order_postal",
    "product_sales",
    "shipping_credits",
    "giftwrap_credits",
    "promotional_rebates",
    "sales_tax_collected",
    "selling_fees",
    "fba_fees",
    "other_transaction_fees",
    "other",
    "total",
  ]


  @spec compile :: Spreadsheet.table
  def compile do
    true
  end
end
