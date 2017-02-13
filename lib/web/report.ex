defmodule Web.Report do
  @moduledoc """
  Exposes functions for getting Amazon Reports.

  """

  @type report :: map
  @typep xml :: any

  import SweetXml
  alias Web

  alias Web.Report.MerchantListingsData
  alias Web.Report.Orders

  @callback get_report :: report


  @spec merchant_listings_data() :: report
  def merchant_listings_data() do
    MerchantListingsData.get_report()
  end

  @spec get_all_reports() :: map
  def get_all_reports() do
    Web.fetch("GetReportList")
    |> SweetXml.parse()
    |> get_report_names_and_ids()
  end

  @spec get_report_by_id(String.t) :: [String.t]
  def get_report_by_id(id) do
    Web.fetch("GetReport", [ReportId: id])
  end

  @spec get_report_names_and_ids(xml) :: %{String.t => String.t}
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


end