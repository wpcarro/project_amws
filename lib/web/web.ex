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
  @merchant_listings_data Application.get_env(:project_amws, :merchant_listings_data)

  @db_path Application.get_env(:project_amws, :lookup_index_paths)

  import SweetXml

  require Logger


  @doc """
  Kicks off the task that downloads the Merchant Listings data and stores the
  contents to disk to avoid making too many requests both in PROD and DEV
  environments.

  """
  @spec run :: :ok | no_return
  def run() do
  end



  @doc """
  WIP: initializes everything.

  """
  @spec init :: :ok | no_return
  defp init() do
    open_db!("reports")

    :ok
  end


  @spec stream_merchant_listings_data() :: Enumerable.t
  def stream_merchant_listings_data() do
    db =
      open_db!("reports")

    download_merchant_listings_data!(use_cached: true)
    |> Stream.map(&remove_invalid_chars/1)
    |> CSV.decode(headers: true, separator: ?\t)
    |> save_csv(db)
  end


  @spec open_db!(String.t) :: Rox.db_handle | no_return
  def open_db!(name) do
    IO.inspect(@db_path, label: "DB Path")

    file_path =
      Path.join(@db_path, "#{name}.rocksdb")

    with {:ok, db} <- Rox.open(file_path, [create_if_missing: true], []) do
      db
    else
      {:error, err} ->
        raise("Error opening Rox: \n#{inspect(err)}")
    end
  end


  @spec save_csv(Enumerable.t, pid) :: :ok | no_return
  defp save_csv(csv, db) do
    processed_csv =
      Enum.into(csv, [])

    Rox.put(db, "merchant_listings_data", processed_csv)
  end


  @spec download_merchant_listings_data!(Keyword.t) :: Enumerable.t | no_return
  defp download_merchant_listings_data!(opts \\ []) do
    if opts[:use_cached] and File.exists?(@merchant_listings_data) do
      File.stream!(@merchant_listings_data)
    else
      Logger.info("[Web] Downloading Merchant Listings Data.")

      file =
        File.open!("/tmp/merchant_listings_data.tsv", [:write])

      data =
        get_reports()
        |> Map.get("_GET_MERCHANT_LISTINGS_DATA_")
        |> get_report_by_id()

      IO.binwrite(file, data)

      File.close(file)

      Logger.info("[Web] Finished.")
    end
  end

  @spec remove_invalid_chars(binary) :: String.t
  defp remove_invalid_chars(row) when is_binary(row) do
    row
    |> String.split("")
    |> Enum.filter(&String.valid?/1)
    |> Enum.join("")
  end


  @spec get_reports() :: map
  def get_reports() do
    fetch("GetReportList")
    |> SweetXml.parse()
    |> get_report_names_and_ids()
  end


  @spec get_report_by_id(String.t) :: [String.t]
  def get_report_by_id(id) do
    fetch("GetReport", [ReportId: id])
  end


  @spec fetch(String.t, [{atom, any}]) :: String.t
  defp fetch(action, params \\ []) do
    assert_supported_action(action)

    signed_options =
      [
        AWSAccessKeyId: Application.get_env(:project_amws, :aws_key),
        Action: action,
        MWSAuthToken: Application.get_env(:project_amws, :developer_id),
        Merchant: Application.get_env(:project_amws, :seller_id),
        Version: "2009-01-01",
        Timestamp: gen_timestamp()
      ]
      |> Keyword.merge(params)
      |> sign_data()

    url =
      @endpoint <> "?" <> URI.encode_query(signed_options)

    response =
      HTTPotion.post!(url)

    response.body
  end

  defp get_report_names_and_ids(xml) do
    names =
      xml
      |> xpath(~x"//ReportType/text()"l)
      |> Enum.map(&to_string/1)

    ids =
      xml
      |> xpath(~x"//ReportId/text()"l)
      |> Enum.map(&to_string/1)

    Enum.zip(names, ids)
    |> Map.new()
  end


  @spec assert_supported_action(String.t) :: :ok | no_return
  defp assert_supported_action(action) do
    supported_actions =
      ["GetReportList", "GetReport"]

    if not(action in supported_actions) do
      raise(ArgumentError, message: "Action, \"#{action}\" not supported. The following actions are currently supported: \"#{inspect(supported_actions)}\"")
    else
      :ok
    end
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
