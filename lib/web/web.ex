defmodule Web do
  @moduledoc """
  This module contains functions for making API request to Amazon's MWS.

  The basic sections are:

  - Feeds
  - Reports
  - Fulfillment
    - fulfillment_inbound
    - fulfillment_inventory
    - fulfillment_outbound
  - Orders
  - Sellers
  - Products
  - Recommendations
  - Subscriptions
  - Off-Amazon Payments
  - Finances
  - Merchant Fulfillment

  """

  @endpoint "https://mws.amazonservices.com"
  @us_marketplace_id "ATVPDKIKX0DER"

  @app_name Application.get_env(:project_amws, :app_name)
  @app_version Application.get_env(:project_amws, :app_version)
  @app_language Application.get_env(:project_amws, :app_language)
  @app_language_version Application.get_env(:project_amws, :app_language_version)
  @app_platform Application.get_env(:project_amws, :app_platform)


  @api_section_to_operations %{
    "Feeds": [
      "CancelFeedSubmissions",
      "GetFeedSubmissionList",
      "GetFeedSubmissionListByNextToken",
      "GetFeedSubmissionCount",
      "GetFeedSubmissionResult",
      "SubmitFeed"
    ],
    "Reports": [
      "GetReport",
      "GetReportCount",
      "GetReportList",
      "GetReportListByNextToken",
      "GetReportRequestCount",
      "GetReportRequestList",
      "GetReportRequestListByNextToken",
      "CancelReportRequests",
      "RequestReport",
      "ManageReportSchedule",
      "GetReportScheduleList",
      "GetReportScheduleListByNextToken",
      "GetReportScheduleCount",
      "UpdateReportAcknowledgements"
    ],
    "Fulfillment": [
      fulfillment_inbound: [
        "GetServiceStatus",
        "GetPreorderInfo",
        "ConfirmPreorder",
        "ConfirmTransportRequest",
        "CreateInboundShipment",
        "CreateInboundShipmentPlan",
        "EstimateTransportRequest",
        "GetBillOfLading",
        "GetPalletLabels",
        "GetPackageLabels",
        "GetUniquePackageLabels",
        "GetTransportContent",
        "ListInboundShipmentItems",
        "ListInboundShipmentItemsByNextToken",
        "ListInboundShipments",
        "ListInboundShipmentsByNextToken",
        "PutTransportContent",
        "VoidTransportRequest",
        "UpdateInboundShipment",
        "GetPrepInstructionsForSKU",
        "GetPrepInstructionsForASIN",
        "GetInboundGuidanceForASIN",
        "GetInboundGuidanceForSKU"
      ],
      fulfillment_inventory: [
        "GetServiceStatus",
        "ListInventorySupply",
        "ListInventorySupplyByNextToken",
      ],
      fulfillment_outbound: [
        "GetServiceStatus",
        "CancelFulfillmentOrder",
        "CreateFulfillmentOrder",
        "UpdateFulfillmentOrder",
        "GetFulfillmentOrder",
        "GetFulfillmentPreview",
        "GetPackageTrackingDetails",
        "ListAllFulfillmentOrders",
        "ListAllFulfillmentOrdersByNextToken",
        "CreateFulfillmentReturn",
        "ListReturnReasonCodes",
      ]
    ],
    "Orders": [
      "GetServiceStatus",
      "ListOrders",
      "ListOrdersByNextToken",
      "GetOrder",
      "ListOrderItems",
      "ListOrderItemsByNextToken"
    ],
    "Sellers": [
      "Sellers Retrieval",
      "GetServiceStatus",
      "ListMarketplaceParticipations",
      "ListMarketplaceParticipationsByNextToken"
    ],
    "Products": [
      "GetServiceStatus",
      "ListMatchingProducts",
      "GetMatchingProduct",
      "GetMatchingProductForId",
      "GetCompetitivePricingForSKU",
      "GetCompetitivePricingForASIN",
      "GetLowestPricedOffersForSKU",
      "GetLowestPricedOffersForASIN",
      "GetLowestOfferListingsForSKU",
      "GetLowestOfferListingsForASIN",
      "GetMyFeesEstimate",
      "GetMyPriceForSKU",
      "GetMyPriceForASIN",
      "GetProductCategoriesForSKU",
      "GetProductCategoriesForASIN"
    ],
    "Recommendations": [
      "GetServiceStatus",
      "GetLastUpdatedTimeForRecommendations",
      "ListRecommendations",
      "ListRecommendationsByNextToken"
    ],
    "Subscriptions": [
      "Destinations",
      "GetServiceStatus",
      "RegisterDestination",
      "DeregisterDestination",
      "ListRegisteredDestinations",
      "SendTestNotificationToDestination",
      "Subscriptions",
      "CreateSubscription",
      "GetSubscription",
      "DeleteSubscription",
      "ListSubscriptions",
      "UpdateSubscription"
    ],
    "Off-Amazon Payments": [
      "OffAmazonPayments",
      "GetServiceStatus",
      "GetOrderReferenceDetails",
      "SetOrderReferenceDetails",
      "ConfirmOrderReference",
      "CancelOrderReference",
      "CloseOrderReference",
      "Authorize",
      "GetAuthorizationDetails",
      "CloseAuthorization",
      "Capture",
      "GetCaptureDetails",
      "Refund",
      "GetRefundDetails",
      "CreateOrderReferenceForId",
      "GetBillingAgreementDetails",
      "SetBillingAgreementDetails",
      "ConfirmBillingAgreement",
      "ValidateBillingAgreement",
      "AuthorizeOnBillingAgreement",
      "CloseBillingAgreement"
    ],
    "Finances": [
      "Finances",
      "GetServiceStatus",
      "ListFinancialEventGroups",
      "ListFinancialEventGroupsByNextToken",
      "ListFinancialEvents",
      "ListFinancialEventsByNextToken"
    ],
    "Merchant Fulfillment": [
      "Merchant Fulfillment",
      "GetServiceStatus",
      "GetEligibleShippingServices",
      "CreateShipment",
      "GetShipment",
      "CancelShipment"
    ]
  }


  @spec build_user_agent() :: String.t
  def build_user_agent() do
    name =
      @app_name

    version =
      @app_version

    language =
      @app_language

    platform =
      @app_platform

    do_build_user_agent(name, version, language, platform)
  end

  @spec do_build_user_agent(String.t, String.t, String.t, String.t) :: String.t
  defp do_build_user_agent(name, version, language, platform) do
    name_version =
      name <> "/" <> version

    app_language_info =
      format_app_language_info(language, platform)

    [name_version, app_language_info]
    |> Enum.join(" ")
  end

  @spec format_app_language_info(String.t, String.t) :: String.t
  defp format_app_language_info(language, platform) do
    formatted_language =
      "Language=" <> language

    formatted_platform =
      "Platform=" <> platform

    "(" <> formatted_language <> "; " <> formatted_platform <> ")"
  end


  @spec sign_data(binary) :: binary
  def sign_data(data) when is_binary(data) do
    key =
      Application.get_env(:project_amws, :secret_key)

    :crypto.hmac(:sha256, key, data)
  end


end
