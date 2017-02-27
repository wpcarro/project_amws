defmodule Spreadsheet.CostsBySKU do
  @moduledoc """
  This module holds functions related to creating the "Costs By SKU"
  spreadsheet.

  """

  alias Web.Spreadsheet
  alias Web.Report.MerchantListingsData

  @behaviour Spreadsheet

  @type t :: %__MODULE__{
    sku: String.t,
    product_name: String.t,
    cost_per_unit: float,
  }

  defstruct [
    sku: nil,
    product_name: nil,
    cost_per_unit: nil,
  ]


  @spec compile :: Spreadsheet.table | no_return
  def compile do
    MerchantListingsData.get_report()
    |> Stream.map(&to_row/1)
  end

  defp to_row(record)
  defp to_row(%MerchantListingsData{seller_sku: sku, item_name: name, price: price})
  when is_binary(sku) do
    [sku, name, compute_cost_per_unit(price)]
  end

  @spec compute_cost_per_unit(float) :: float
  defp compute_cost_per_unit(price) when is_float(price) do
    # raise("Not implemented")
    price
  end


end
