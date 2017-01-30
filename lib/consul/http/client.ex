defmodule Consul.HTTP.Client do
  use HTTPoison.Base

  # @type response :: (HTTPoison.Reponse.t | HTTPoison.AsyncResponse.t)

  # @spec call(Consul.Client.Conn.t) :: Consul.Client.Conn.t
  # def call(%{request: request} = conn) do
  #   {:ok, response} = Consul.Client.request(request.method,
  #                                           request.url,
  #                                           request.body,
  #                                           request.headers,
  #                                           request.options)
  #   Consul.Client.Conn.put_response(conn, response)
  # end

  def process_url(url) do
    "http://localhost:8500/#{url}"
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
    |> Poison.encode!
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
    parsed_value = case Poison.Parser.parse(decoded_value) do
      {:ok, parsed} -> parsed
      {:error, {:invalid, _, _}} -> decoded_value
    end
    %{item | "Value" => parsed_value}
  end
  defp decode_body(item) do
    item
  end
end
