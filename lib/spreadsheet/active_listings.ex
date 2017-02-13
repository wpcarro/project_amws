defmodule Spreadsheet.ActiveListings do
  @moduledoc """
  This module holds functions related to creating the "Active Listings"
  spreadsheet.

  """

  alias Web.Spreadsheet

  @behaviour Spreadsheet


  @fields [
    "item-name",
    "item-description",
    "listing-id",
    "seller-sku",
    "price",
    "quantity",
    "open-date",
    "image-url",
    "item-is-marketplace",
    "product-id-type",
    "zshop-shipping-fee",
    "item-note",
    "item-condition",
    "zshop-category1",
    "zshop-browse-path",
    "zshop-storefront-feature",
    "asin1",
    "asin2",
    "asin3",
    "will-ship-internationally",
    "expedited-shipping",
    "zshop-boldface",
    "product-id",
    "bid-for-featured-placement",
    "add-delete",
    "pending-quantity",
    "fulfillment-channel",
    "merchant-shipping-group",
  ]


  @spec compile :: Spreadsheet.table
  def compile do
    true
  end
end
