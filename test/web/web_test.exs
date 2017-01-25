defmodule WebTest do
  use ExUnit.Case


  test "build_user_agent/1" do
    assert Web.build_user_agent() ==
      "velocity_sellers/0.1 (Language=Elixir/1.4; Platform=Mac OS X)"
  end
end
