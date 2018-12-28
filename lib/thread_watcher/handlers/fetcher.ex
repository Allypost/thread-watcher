defmodule ThreadWatcher.Handlers.Fetcher do
  @spec fetch(String.t(), String.t()) :: {atom(), String.t() | map()}
  def fetch(url, error_message \\ "Resource doesn't exist") do
    headers = get_fetch_headers()

    url
    |> :hackney.get(headers)
    |> handle_response(error_message)
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

  defp handle_response({:ok, 200, _headers, reference}, _errorMessage) do
    case :hackney.body(reference) do
      {:ok, body} ->
        body
        |> Jason.decode(keys: :atoms)
        |> parse_body()

      _ ->
        error_response()
    end
  end

  defp handle_response({:ok, 404, _, _}, error_message), do: error_response(error_message)
  defp handle_response({:error, _}, _), do: error_response()

  defp parse_body({:ok, data}), do: {:ok, data}
  defp parse_body({:error, _}), do: error_response()

  defp error_response(error_message \\ "Something went wrong"), do: {:error, error_message}
end
