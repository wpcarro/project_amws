defmodule Web.Report.ReservedInventoryData do
  @moduledoc """
  Houses functions related to the "Reserved Inventory Data" report.

  """

  import Decoder.Helpers

  require Logger
  alias Web.Report
  alias __MODULE__

  @behavor Report

  @type t :: %__MODULE__{
    sku: String.t, fnsku: String.t, asin: String.t, product_name: String.t,
    reserved_qty: String.t, reserved_customer_orders: String.t,
    reserved_fc_transfers: String.t, reserved_fc_processing: String.t,
  }

  defstruct [
    :sku,
    :fnsku,
    :asin,
    :product_name,
    :reserved_qty,
    :reserved_customer_orders,
    :reserved_fc_transfers,
    :reserved_fc_processing,
  ]

  @reserved_inventory_data "/tmp/reserved_inventory_data.tsv"
  @reserved_inventory_data_id "4365069136017223"


  def init do
    raise("Not implemented")
  end

  def get_report do
    filepath =
      if File.exists?(@reserved_inventory_data) do
        @reserved_inventory_data
      else
        with :ok <- get_and_save_reserved_inventory_data() do
          @reserved_inventory_data
        end
      end

    File.read!(filepath)
    |> String.split(~r/[\n\r]/, trim: true)
    |> Stream.drop(1)
    |> CSV.decode(headers: false, separator: ?\t)
    |> Stream.map(&decode/1)
  end

  @spec get_and_save_reserved_inventory_data :: :ok | no_return
  defp get_and_save_reserved_inventory_data do
    Logger.info("[Report] Downloading Reserved Inventory Data.")

    file =
      File.open!(@reserved_inventory_data, [:write])

    data =
      Report.get_report_by_id(@reserved_inventory_data_id)

    IO.binwrite(file, data)
    File.close(file)
    Logger.info("[Report] Finished.")
  end

  @doc """
  Decodes a raw response from AMWS into `ReservedInventoryData.t`

  """
  @spec decode([String.t]) :: t
  defp decode(record) do
    [
      sku, fnsku, asin, product_name, reserved_qty, reserved_customer_orders,
      reserved_fc_transfers, reserved_fc_processing,
    ] = record

    %ReservedInventoryData{
      sku: sku, fnsku: fnsku, asin: asin, product_name: product_name,
      reserved_qty: reserved_qty |> String.to_integer(),
      reserved_customer_orders: reserved_customer_orders |> String.to_integer(),
      reserved_fc_transfers: reserved_fc_transfers |> String.to_integer(),
      reserved_fc_processing: reserved_fc_processing |> String.to_integer(),
    }
  end


end
