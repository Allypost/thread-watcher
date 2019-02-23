defmodule ThreadWatcher.Fetchers.Fetcher do
  @type headers() :: [{String.t(), String.t()}]
  @type error() :: {:error, String.t()}
  @type resp() :: {:ok, map()}
  @type resp_raw() :: {:ok, map(), headers()}

  @spec fetch(String.t(), String.t(), headers()) :: error() | resp()
  def fetch(url, error_message \\ "Resource doesn't exist", headers \\ get_fetch_headers()) do
    url
    |> :hackney.get(headers)
    |> handle_response(error_message)
  end

  @spec fetch_raw(String.t(), String.t(), headers()) :: error() | resp_raw()
  def fetch_raw(url, error_message \\ "Resource doesn't exist", headers \\ get_fetch_headers()) do
    url
    |> :hackney.get(headers)
    |> handle_raw_response(error_message)
  end

  defp headers() do
    %{
      "User-Agent": "ThreadPuller",
      Referer: "https://boards.4chan.org/"
    }
  end

  defp get_fetch_headers() do
    headers()
    |> Enum.into([])
    |> Enum.map(fn {k, v} -> {Atom.to_string(k), v} end)
  end

  defp handle_response(response, error_message) do
    case handle_raw_response(response, error_message) do
      {:ok, data, _} ->
        Jason.decode(data, keys: :atoms)
        |> parse_body()

      other ->
        other
    end
  end

  defp handle_raw_response({:ok, 200, headers, reference}, _error_message) do
    case :hackney.body(reference) do
      {:ok, body} ->
        {:ok, body, headers}

      _ ->
        error_response()
    end
  end

  defp handle_raw_response({:error, _}, _), do: error_response()
  defp handle_raw_response(status, error_message) do
    IO.inspect(status)

    error_response(error_message)
  end

  defp parse_body({:ok, data}), do: {:ok, data}
  defp parse_body({:error, _}), do: error_response()

  defp error_response(error_message \\ "Something went wrong"), do: {:error, error_message}
end
