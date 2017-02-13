defmodule Spreadsheet.StorageReport do
  @moduledoc """
  This module holds functions related to creating the "Storage Report"
  spreadsheet.

  """

  alias Web.Spreadsheet

  @behaviour Spreadsheet


  @fields [
    "asin",
    "fnsku",
    "product_name",
    "fulfillment_center",
    "country_code",
    "longest_side",
    "median_side",
    "shortest_side",
    "measurement_units",
    "weight",
    "weight_units",
    "item_volume",
    "volume_units",
    "product_size_tier",
    "average_quantity_on_hand",
    "average_quantity_pending_removal",
    "estimated_total_item_volume",
    "month_of_charge",
    "storage_rate",
    "currency",
    "estimated_monthly_storage_fee",
  ]


  @spec compile :: Spreadsheet.table
  def compile do
    true
  end
end
