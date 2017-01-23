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
    ],
    "Fulfillment": [],
    "Orders": [],
    "Sellers": [],
    "Products": [],
    "Recommendations": [],
    "Subscriptions": [],
    "Off-Amazon Payments Sandbox": [],
    "Off-Amazon Payments": []
  }

POST /?AWSAccessKeyId=AKIAIA5G4UHWLURF3FUQ
  &Action=GetReportList
  &Merchant=A2PVRGI9GXOFMB
  &MWSAuthToken=4457-4543-1111
  &SignatureVersion=2
  &Timestamp=2017-01-23T05%3A33%3A49Z
  &Version=2009-01-01
  &Signature=oS6JevFUkHmLp%2BRB6GyuiisUS5VNg9ICuoX5VmoKwq4%3D



  @spec get_credentials() :: [key: String.t]
  def get_credentials() do
    @credential_keys
    |> Enum.reduce([], &Keyword.put(&2, &1, Application.get_env(:project_amws, &1)))
  end


  def get_skus() do
    get_credentials()
  end


end
