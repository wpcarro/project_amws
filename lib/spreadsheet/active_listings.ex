defmodule Spreadsheet.ActiveListings do
  @moduledoc """
  This module holds functions related to creating the "Active Listings"
  spreadsheet.

  """

  alias Web.Spreadsheet
  alias Web.Report.MerchantListingsData

  @behaviour Spreadsheet

  @type t :: %__MODULE__{
    item_name: String.t,
    item_description: String.t,
    listing_id: String.t,
    seller_sku: String.t,
    price: float,
    quantity: integer | nil,
    open_date: DateTime.t,
    # image_url: String.t,
    item_is_marketplace: boolean,
    product_id_type: String.t,
    # zshop_shipping_fee: String.t,
    # item_note: String.t,
    item_condition: String.t,
    # zshop_category1: String.t,
    # zshop_browse_path: String.t,
    # zshop_storefront_feature: String.t,
    asin1: String.t,
    # asin2: String.t,
    # asin3: String.t,
    will_ship_internationally: boolean,
    expedited_shipping: boolean,
    # zshop_boldface: String.t,
    product_id: String.t,
    # bid_for_featured_placement: String.t,
    # add_delete: String.t,
    pending_quantity: integer,
    fulfillment_channel: String.t,
    merchant_shipping_group: String.t,
  }

  defstruct [
    :item_name, :item_description, :listing_id, :seller_sku, :price, :quantity,
    :open_date, :item_is_marketplace, :product_id_type, :item_condition, :asin1,
    :will_ship_internationally, :expedited_shipping, :product_id,
    :pending_quantity, :fulfillment_channel, :merchant_shipping_group,
  ]


  @spec compile :: Spreadsheet.table
  def compile do
    MerchantListingsData.get_report()
    |> Stream.map(&to_row/1)
  end

  defp to_row(record)
  defp to_row(%MerchantListingsData{seller_sku: sku} = record) when is_binary(sku) do
    %{
      item_name: name, item_description: description, listing_id: listing_id,
      price: price, quantity: quantity, open_date: date,
      item_is_marketplace: marketplace?, product_id_type: product_id_type,
      asin1: asin, will_ship_internationally: ship_internationally?,
      expedited_shipping: expedited_shipping?, product_id: product_id,
      pending_quantity: pending_quantity,
      fulfillment_channel: fulfillment_channel,
      merchant_shipping_group: merchant_shipping_group,
    } = record

    [
      sku, name, description, listing_id, sku, price, quantity, date,
      marketplace?, product_id_type, asin, ship_internationally?,
      expedited_shipping?, product_id, pending_quantity, fulfillment_channel,
      merchant_shipping_group,
    ]
  end


end
