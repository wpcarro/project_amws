defmodule Spreadsheet.CostsBySKU do
  @moduledoc """
  This module holds functions related to creating the "Costs By SKU"
  spreadsheet.

  """

  alias Web.Spreadsheet
  alias Web.Report.MerchantListingsData
  import Logger

  @behaviour Spreadsheet

  @typep sku :: String.t
  @typep product_name :: String.t
  @typep cost_per_unit :: float

  @type t :: %__MODULE__{
    sku: sku,
    product_name: product_name,
    cost_per_unit: cost_per_unit,
  }

  defstruct [
    sku: nil,
    product_name: nil,
    cost_per_unit: nil,
  ]


  @spec compile :: Spreadsheet.table | no_return
  def compile do
    assert_report_dependencies!()

    do_compile()
  end

  @spec do_compile :: Spreadsheet.table | no_return
  defp do_compile do
    MerchantListingsData.get_report()
    |> Stream.map(&to_row/1)
  end

  defp to_row(record)
  defp to_row(%MerchantListingsData{seller_sku: sku, item_name: name, price: price})
  when is_binary(sku) do
    [sku, name, compute_cost_per_unit(price)]
  end

  @spec assert_report_dependencies! :: :ok | no_return
  defp assert_report_dependencies! do
    with :ok <- :ok do
      :ok
    else
      _ -> Logger.warn("Trouble fetching dependencies for CostsBySKU Spreadsheet. Aborting.")
    end
  end

  @spec compute_cost_per_unit(float) :: cost_per_unit
  defp compute_cost_per_unit(price) when is_float(price) do
    # raise("Not implemented")
    price
  end


  # defimpl Savable do
  # `sku` is the primary key
  #   def to_sql(record) do
  #     {@index, record.sku}
  #   end
  # end


end
