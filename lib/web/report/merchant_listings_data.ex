defmodule Web.Report.MerchantListingsData do
  @moduledoc """
  Houses functions related to the "Merchant Listings Data" report

  """

  require Logger
  alias Web.Report

  @behaviour Report

  @merchant_listings_data "/tmp/merchant_listings_data.tsv"
  @merchant_listings_data_id "4231024711017210"

  @spec get_report() :: Report.t
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
    |> Enum.into([])
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
