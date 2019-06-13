defmodule Consul.HTTP.Client do
  @moduledoc false
  require Logger

  use HTTPoison.Base

  def process_url(query) do
    "http://#{base_url()}/#{query}"
  end

  def process_response_body(body) do
    case Poison.decode(body) do
      {:ok, decoded_body} ->
        decode_body(decoded_body)

      _ ->
        body
    end
  end

  def process_request_body(body) when is_binary(body) do
    body
  end

  def process_request_body(body) do
    body
    |> Poison.encode!()
  end

  def process_headers(headers) do
    headers
  end

  def process_status_code(status_code) do
    status_code
  end

  defp decode_body(items) when is_list(items) do
    Enum.map(items, &decode_body/1)
  end

  defp decode_body(%{"Value" => value} = item) when is_binary(value) do
    decoded_value = :base64.decode(value)

    parsed_value =
      case Poison.Parser.parse(decoded_value) do
        {:ok, parsed} -> parsed
        {:error, {:invalid, _, _}} -> decoded_value
      end

    %{item | "Value" => parsed_value}
  end

  defp decode_body(item) do
    item
  end

  defp base_url do
    System.get_env("CONSUL_BASE_URL") || Application.get_env(:consul, :base_url, "localhost:8500")
  end

  def request(method, url, body \\ "", headers \\ [], opts \\ []) do
    response = super(url, body, headers, opts)

    Logger.info(fn ->
      """
      [CONSUL] #{inspect(method)} #{inspect(url)},
      body: #{inspect(body)}, headers: #{inspect(headers)}, opts: #{inspect(opts)},
      response: #{inspect(response)}
      """
    end)

    response
  end
end
