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

  @endpoint "https://mws.amazonservices.com/"

  @app_name Application.get_env(:project_amws, :app_name)
  @app_version Application.get_env(:project_amws, :app_version)
  @app_language Application.get_env(:project_amws, :app_language)
  @app_language_version Application.get_env(:project_amws, :app_language_version)
  @app_platform Application.get_env(:project_amws, :app_platform)

  import SweetXml


  @spec get_reports() :: any
  def get_reports() do
    signed_options =
      [
        AWSAccessKeyId: Application.get_env(:project_amws, :aws_key),
        Action: "GetReportList",
        MWSAuthToken: Application.get_env(:project_amws, :developer_id),
        Merchant: Application.get_env(:project_amws, :seller_id),
        Version: "2009-01-01",
        Timestamp: gen_timestamp()
      ]
      |> sign_data()

    url =
      @endpoint <> "?" <> URI.encode_query(signed_options)

    HTTPotion.post!(url)
  end

  def parse_response(%{body: body}) do
    SweetXml.parse(body)
  end

  def get_report_names_and_ids(xml) do
    names =
      xml
      |> xpath(~x"//ReportType/text()"l)
      |> Enum.map(&to_string/1)

    ids =
      xml
      |> xpath(~x"//ReportRequestId/text()"l)
      |> Enum.map(&to_string/1)

    Enum.zip(ids, names)
    |> Map.new()
  end

  @spec gen_timestamp() :: String.t
  defp gen_timestamp() do
    Timex.now()
    |> Timex.format!("{ISO:Extended}")
  end

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


  @doc """
  Replaces "+" separators with "%20" per AMWS reqs.

  """
  @spec amws_encode_query([{atom, any}]) :: String.t
  def amws_encode_query(query) when is_list(query) do
    query
    |> URI.encode_query()
    |> String.replace("+", "%20")
    |> String.replace("*", "%2A")
    |> String.replace("%7E","~")
  end


  @spec gen_canonicalized_query_string!([{atom, any}]) :: String.t | no_return
  def gen_canonicalized_query_string!(query) do
    query
    |> gen_canonicalized_fields!()
    |> amws_encode_query()
  end

  @spec gen_canonicalized_fields!([{atom, any}]) :: [{atom, any}] | no_return
  defp gen_canonicalized_fields!(query) do
    required_fields =
      [:AWSAccessKeyId, :Action, :MWSAuthToken, :Merchant, :Timestamp, :Version]

    assert_required_fields(query, required_fields)

    query
    |> Keyword.put(:SignatureMethod, "HmacSHA256")
    |> Keyword.put(:SignatureVersion, 2)
    |> Enum.sort()
  end

  # TODO: Keyword.Extra.assert_required_fields/2
  @spec assert_required_fields([{atom, any}], [atom]) :: :ok | no_return
  def assert_required_fields(input, fields) do
    Enum.each(fields, fn field ->
      if not(Keyword.has_key?(input, field)) do
        raise(ArgumentError, message: "Required field, \"#{field}\" is not present in \"#{inspect(input)}\"")
      end
    end)
    :ok
  end

  @spec sign_data([{atom, any}], String.t) :: [{atom, any}]
  def sign_data(query, http_verb \\ "POST") when is_list(query) do
    key =
      Application.get_env(:project_amws, :secret_key)

    query_string =
      gen_canonicalized_query_string!(query)

    string_to_sign =
      [
        http_verb,
        "mws.amazonservices.com",
        "/",
        query_string
      ]
      |> Enum.join("\n")

    signature =
      :crypto.hmac(:sha256, key, string_to_sign)
      |> Base.encode64()

    gen_canonicalized_fields!(query) ++ [Signature: signature]
  end


end
