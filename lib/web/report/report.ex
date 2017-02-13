defmodule Web.Report do
  @moduledoc """
  Exposes functions for getting Amazon Reports.

  """

  require Logger
  import SweetXml
  alias Web

  @merchant_listings_data "/tmp/merchant_listings_data.tsv"



  @spec get_all_reports() :: map
  def get_all_reports() do
    Web.fetch("GetReportList")
    |> SweetXml.parse()
    |> get_report_names_and_ids()
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

  @spec merchant_listings_data() :: :ok | no_return
  def merchant_listings_data() do
    if File.exists?(@merchant_listings_data) do
      :ok
    else
      get_and_save_merchant_listings_data()
    end
  end

  @spec get_report_by_id(String.t) :: [String.t]
  def get_report_by_id(id) do
    fetch("GetReport", [ReportId: id])
    # |> CSV.decode(headers: true, separator: ?\t)
  end

  @spec get_and_save_merchant_listings_data() :: :ok | no_return
  defp get_and_save_merchant_listings_data() do
    Logger.info("[Web] Downloading Merchant Listings Data.")

    file =
      File.open!(@merchant_listings_data, [:write])

    data =
      get_all_reports()
      |> Map.get("_GET_MERCHANT_LISTINGS_DATA_")
      |> get_report_by_id()

    IO.binwrite(file, data)

    File.close(file)

    Logger.info("[Web] Finished.")
  end


end
