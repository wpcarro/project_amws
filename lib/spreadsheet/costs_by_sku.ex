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
    with :ok <- get_report_dependencies() do
      do_compile()
    else
      _ ->
        Logger.warn("Trouble fetching dependencies for CostsBySKU Spreadsheet. Aborting.")
    end
  end

  @spec do_compile :: Spreadsheet.table | no_return
  defp do_compile do
    skus =
      MerchantListingsData.get_report()

    product_names =
      get_product_names(skus)

    costs_per_unit =
      get_costs_per_unit(skus)

    %{
      sku: [1, 2, 3],
      product_name: product_names,
      costs_per_unit: costs_per_unit,
    }
  end

  @spec get_report_dependencies() :: :ok | no_return
  defp get_report_dependencies() do
  end

  @spec get_product_names([sku]) :: [product_name]
  defp get_product_names(skus) do
    skus
    |> Stream.map(&get_product_name/1)
    |> Enum.into([])
  end

  @spec get_product_name(sku) :: product_name
  defp get_product_name(sku) do
    # make API call here
  end

  @spec get_costs_per_unit([sku]) :: [cost_per_unit]
  defp get_costs_per_unit(skus) do
    skus
    |> Stream.map(&get_cost_per_unit/1)
    |> Enum.into([])
  end

  @spec get_cost_per_unit(sku) :: cost_per_unit
  defp get_cost_per_unit(sku) do
    # make API call here
  end
end
