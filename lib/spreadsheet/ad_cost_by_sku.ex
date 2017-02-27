defmodule Spreadsheet.AdCostBySKU do
  @moduledoc """
  This module holds functions related to creating the "Ad Cost By SKU"
  spreadsheet.

  """

  alias Web.Spreadsheet

  @behaviour Spreadsheet

  @type t :: %__MODULE__{
    start_date: DateTime.t,
    end_date: DateTime.t,
    merchant_name: String.t,
    sku: String.t,
    clicks: integer,
    impressions: integer,
    ctr: float,
    currency: String.t,
    total_spend: float,
    average_cpc: float,
  }

  defstruct [
    :start_date,
    :end_date,
    :merchant_name,
    :sku,
    :clicks,
    :impressions,
    :ctr,
    :currency,
    :total_spend,
    :average_cpc,
  ]



  @spec compile :: Spreadsheet.table
  def compile do
  end


end
