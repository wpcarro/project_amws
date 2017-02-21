defmodule Web.Report.MerchantListingsDataTest do
  use ExUnit.Case

  alias Web.Report.MerchantListingsData

  test "decode/1" do
    input = %MerchantListingsData{
    }

    assert MerchantListingsData.decode(input) == %{
    }
  end
end
