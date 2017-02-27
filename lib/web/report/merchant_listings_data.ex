defmodule Web.Report.MerchantListingsData do
  @moduledoc """
  Houses functions related to the "Merchant Listings Data" report

  """

  import Decoder.Helpers

  require Logger
  alias Web.Report
  alias __MODULE__

  @behaviour Report

  @type t :: %{
    item_name: String.t, item_description: String.t, listing_id: String.t,
    seller_sku: String.t, price: float, quantity: non_neg_integer,
    open_date: DateTime.t, image_url: String.t, item_is_marketplace: boolean,
    product_id_type: String.t, zshop_shipping_fee: String.t, item_note: String.t,
    item_condition: String.t, zshop_category1: any, zshop_browse_path: any,
    zshop_storefront_feature: String.t, asin1: String.t,
    asin2: String.t, asin3: String.t, will_ship_internationally: boolean,
    expedited_shipping: String.t,
    zshop_boldface: String.t, product_id: String.t,
    bid_for_featured_placement: String.t, add_delete: String.t,
    pending_quantity: String.t, fulfillment_channel: String.t,
    merchant_shipping_group: String.t,
  }

  defstruct [
    :item_name, :item_description, :listing_id, :seller_sku, :price, :quantity,
    :open_date, :image_url, :item_is_marketplace, :product_id_type,
    :zshop_shipping_fee, :item_note, :item_condition, :zshop_category1,
    :zshop_browse_path, :zshop_storefront_feature, :asin1, :asin2, :asin3,
    :will_ship_internationally, :expedited_shipping, :zshop_boldface,
    :product_id, :bid_for_featured_placement, :add_delete, :pending_quantity,
    :fulfillment_channel, :merchant_shipping_group,
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
      |> Stream.map(&decode/1)
      # |> Enum.reduce(@empty_table, &build_table/2)
      # |> save_table!()
    else
      _ ->
        Logger.warn("Could not create table for Merchant Listings Data.")
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
    |> Stream.drop(1)
    |> CSV.decode(headers: false, separator: ?\t)
    |> Stream.map(&decode/1)
  end

  @spec get_fields(String.t) :: [String.t]
  def get_fields(field) do
    :ets.lookup(@table_id, field)
  end


  @doc """
  Decodes a raw response from AMWS into `MerchantListingsData.t`

  """
  @time_format "{YYYY}-{0M}-{0D} {h24}:{m}:{s} {Zabbr}"
  @spec decode(String.t) :: t
  def decode(raw) do
    [
      item_name, item_description, listing_id, seller_sku, price, quantity,
      open_date, image_url, item_is_marketplace, product_id_type,
      zshop_shipping_fee, item_note, item_condition, zshop_category1,
      zshop_browse_path, zshop_storefront_feature, asin1, asin2, asin3,
      will_ship_internationally, expedited_shipping, zshop_boldface, product_id,
      bid_for_featured_placement, add_delete, pending_quantity,
      fulfillment_channel, merchant_shipping_group,
    ] = raw

    %MerchantListingsData{
      item_name: item_name |> empty_as_nil(),
      item_description: item_description |> empty_as_nil(),
      listing_id: listing_id |> empty_as_nil(),
      seller_sku: seller_sku |> empty_as_nil(),
      price: price |> empty_as_nil() |> nil_friendly(&coerce_as_float/1),
      quantity: quantity,
      open_date: open_date |> Timex.parse!(@time_format),
      image_url: image_url |> empty_as_nil(),
      item_is_marketplace: item_is_marketplace |> empty_as_nil() |> nil_friendly(&coerce_as_bool(&1, "y", "n")),
      product_id_type: product_id_type |> empty_as_nil(),
      zshop_shipping_fee: zshop_shipping_fee |> empty_as_nil(),
      item_note: item_note |> empty_as_nil(),
      item_condition: item_condition |> empty_as_nil(),
      zshop_category1: zshop_category1 |> empty_as_nil(),
      zshop_browse_path: zshop_browse_path |> empty_as_nil(),
      zshop_storefront_feature: zshop_storefront_feature |> empty_as_nil(),
      asin1: asin1 |> empty_as_nil(),
      asin2: asin2 |> empty_as_nil(),
      asin3: asin3 |> empty_as_nil(),
      will_ship_internationally: will_ship_internationally |> empty_as_nil() |> nil_friendly(&coerce_as_bool(&1, "1")),
      expedited_shipping: expedited_shipping |> empty_as_nil() |> nil_friendly(&coerce_as_bool(&1, "Y", "N")),
      zshop_boldface: zshop_boldface |> empty_as_nil(),
      product_id: product_id |> empty_as_nil(),
      bid_for_featured_placement: bid_for_featured_placement |> empty_as_nil(),
      add_delete: add_delete |> empty_as_nil(),
      pending_quantity: pending_quantity |> empty_as_nil(),
      fulfillment_channel: fulfillment_channel |> empty_as_nil(),
      merchant_shipping_group: merchant_shipping_group |> empty_as_nil(),
    }
  end

  @spec build_table(map, map) :: :ok | no_return
  defp build_table(table, row) do
    Map.Extra.merge_with_concat(table, row)
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
