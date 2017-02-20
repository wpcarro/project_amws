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
    skus =
      MerchantListingsData.get_fields("seller-sku")

    product_names =
      MerchantListingsData.get_fields("item-name")

    costs_per_unit =
      MerchantListingsData.get_fields("price")
      |> Stream.map(&compute_cost_per_unit/1)
      |> Enum.into([])

    %{
      sku: [1, 2, 3],
      product_name: product_names,
      costs_per_unit: costs_per_unit,
    }
  end

  @spec assert_report_dependencies! :: :ok | no_return
  defp assert_report_dependencies! do
    with :ok <- :ok do
      :ok
    else
      _ -> Logger.warn("Trouble fetching dependencies for CostsBySKU Spreadsheet. Aborting.")
    end
  end

  @spec compute_cost_per_unit(String.t) :: cost_per_unit
  defp compute_cost_per_unit(price) do
    # raise("Not implemented")
    price
  end


end
