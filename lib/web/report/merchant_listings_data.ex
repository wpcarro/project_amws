defmodule Web.Report.MerchantListingsData do
  @moduledoc """
  Houses functions related to the "Merchant Listings Data" report

  """

  require Logger
  alias Web.Report

  @behaviour Report

  @fields [
    "item-name", "item-description", "listing-id", "seller-sku", "price",
    "quantity", "open-date", "image-url", "item-is-marketplace",
    "product-id-type", "zshop-shipping-fee", "item-note", "item-condition",
    "zshop-category1", "zshop-browse-path", "zshop-storefront-feature", "asin1",
    "asin2", "asin3", "will-ship-internationally", "expedited-shipping",
    "zshop-boldface", "product-id", "bid-for-featured-placement", "add-delete",
    "pending-quantity", "fulfillment-channel", "merchant-shipping-group",
  ]

  @merchant_listings_data "/tmp/merchant_listings_data.tsv"
  @merchant_listings_data_id "4231024711017210"
  @table_id __MODULE__


  @doc """
  Initializes the ETS table to store the downloaded Merchant Listings Data.

  """
  @spec init :: :ok | no_return
  def init do
    with tid when is_integer(tid) <- :ets.new(@table_id, []) do
      get_report()
      |> Stream.take(2)
      |> Enum.reduce(%{}, &build_table/2)
      # |> save_table!()
    else
      _ -> Logger.warn("Could not create table for Merchant Listings Data.")
    end
  end

  @spec get_report() :: Enumerable.t
  def get_report() do
    filepath =
      if File.exists?(@merchant_listings_data) do
        @merchant_listings_data
      else
        with :ok <- get_and_save_merchant_listings_data() do
          @merchant_listings_data
        end
      end

    File.read!(filepath)
    |> String.split("\n")
    |> Stream.map(&remove_corrupt_string_data/1)
    |> CSV.decode(headers: true, separator: ?\t)
  end

  @spec get_fields(String.t) :: [String.t]
  def get_fields(field) do
    :ets.lookup(@table_id, field)
  end

  @spec build_table(map, map) :: :ok | no_return
  defp build_table(table, row) do
    row
    |> Enum.reduce(table, fn {key, value}, table ->
      IO.inspect(key, label: "key")
      IO.inspect(value, label: "value")

      Map.update(table, key, [value], &[value | &1])
    end)
  end

  @spec save_table!(map) :: :ok | no_return
  defp save_table!(table) do
    :ets.insert(@table_id, table)
  end

  @spec get_and_save_merchant_listings_data() :: :ok | no_return
  defp get_and_save_merchant_listings_data() do
    Logger.info("[Report] Downloading Merchant Listings Data.")

    file =
      File.open!(@merchant_listings_data, [:write])

    data =
      Report.get_report_by_id(@merchant_listings_data_id)

    IO.binwrite(file, data)
    File.close(file)
    Logger.info("[Report] Finished.")
  end

  @spec remove_corrupt_string_data(String.t) :: String.t
  defp remove_corrupt_string_data(line) do
    line
    |> String.split("")
    |> Enum.filter(&String.valid?/1)
    |> Enum.join("")
  end

end
