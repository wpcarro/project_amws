defmodule ProfitBySKUTest do
  use ExUnit.Case

  alias Spreadsheet.ProfitBySKU

  test "compile/1" do
    assert ProfitBySKU.compile()
  end
end
