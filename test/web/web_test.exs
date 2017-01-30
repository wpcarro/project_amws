defmodule WebTest do
  use ExUnit.Case


  test "assert_required_fields/1" do
    fields =
      [:name, :age, :weight]

    input =
      [name: "Brian Anon", age: 21, weight: 200]

    assert Web.assert_required_fields(input, fields) == :ok
    assert_raise(ArgumentError, fn -> Web.assert_required_fields(input, [:not_present]) end)
  end

  test "amws_encode_query/1" do
    input = [
      this: "is a",
      test: "."
    ]

    expected =
      "this=is%20a&test=."

    Web.amws_encode_query(input) == expected
  end

  test "sign_data/1" do
    secret_key =
      "i-am-a-secret"

    time =
      Timex.format!(Timex.now(), "{ISO:Extended}")

    data = [
      AWSAccessKeyId: "aws-access-key-id",
      Action: "GetData",
      MWSAuthToken: "mws-auth-token",
      Merchant: "merchant-id",
      Version: "1.0.0",
      Timestamp: time
    ]

    signature =
      :crypto.hmac(:sha256, secret_key, URI.encode_query(data))

    result =
      Web.sign_data(data)

    assert result |> is_list()
    assert result |> Keyword.has_key?(:SignatureMethod)
    assert result |> Keyword.has_key?(:SignatureVersion)
    assert result |> Keyword.has_key?(:Signature)
    assert [
      {:AWSAccessKeyId, _},
      {:Action, _},
      {:MWSAuthToken, _},
      {:Merchant, _},
      {:SignatureMethod, _},
      {:SignatureVersion, _},
      {:Timestamp, _},
      {:Version, _},
      {:Signature, _}
    ] = result
  end
end
