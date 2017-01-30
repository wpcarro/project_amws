defmodule ProjectAmws.Mixfile do
  use Mix.Project

  def project do
    [app: :project_amws,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end


  def application do
    non_secret_env = [
      app_name: "velocity_sellers",
      app_version: "0.1",
      app_language: "Elixir",
      app_language_version: "1.4",
      app_platform: "Mac OS X",
    ]

    secret_env =
      build_secret_env()

    env =
      Keyword.merge(non_secret_env, secret_env)

    [
      extra_applications: [:logger, :httpotion],
      env: env
    ]
  end

  @spec build_secret_env() :: [key: String.t]
  defp build_secret_env() do
    File.read!("./secret_info.txt")
    |> String.split("\n", trim: true)
    |> do_build_secret_env([])
  end

  @spec do_build_secret_env([String.t], [key: String.t]) :: [key: String.t]
  defp do_build_secret_env(lines, kw_list)
  defp do_build_secret_env([], kw_list), do: kw_list
  defp do_build_secret_env([line | lines], kw_list) do
    [key, value] =
      line
      |> String.split(":")
      |> Enum.map(&String.trim/1)

    kw_list =
      Keyword.put(kw_list, keyify(key), value)

    do_build_secret_env(lines, kw_list)
  end

  @spec keyify(String.t) :: String.t
  defp keyify (key) do
    key
    |> String.downcase()
    |> String.replace(~r/\s+/, "_")
    |> String.to_atom()
  end


  defp deps do
    [
      {:httpotion, "~> 3.0.2"},
      {:timex, "~> 3.1"},
      {:sweet_xml, "~> 0.6.4"},
      {:csv, "~> 1.4"}
    ]
  end
end
