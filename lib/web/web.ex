defmodule Web do

  @endpoint "https://mws.amazonservices.com"
  @us_marketplace_id "ATVPDKIKX0DER"
  @credential_keys ~w(seller_id developer_id aws_key secret_key)a


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
    ]
    "Merchant Fulfillment": [
      "Merchant Fulfillment",
      "GetServiceStatus",
      "GetEligibleShippingServices",
      "CreateShipment",
      "GetShipment",
      "CancelShipment"
    ]
  }


  @spec get_credentials() :: [key: String.t]
  def get_credentials() do
    @credential_keys
    |> Enum.reduce([], &Keyword.put(&2, &1, Application.get_env(:project_amws, &1)))
  end


  def get_skus() do
    get_credentials()
  end


end
