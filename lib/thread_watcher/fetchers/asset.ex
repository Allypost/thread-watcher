defmodule ThreadWatcher.Fetchers.Asset do
  alias ThreadWatcher.Fetchers.Fetcher

  @spec fetch(String.t(), String.t()) :: Fetcher.error() | Fetcher.resp_raw()
  def fetch(board, file) do
    board
    |> url(file)
    |> Fetcher.fetch_raw("File not found", get_fetch_headers(board))
  end

  defp base_url(), do: "https://i.4cdn.org"
  defp url(board, file), do: "#{base_url()}/#{board}/#{file}"

  defp headers(board) do
    %{
      "accept-encoding": "gzip, deflate",
      "user-agent": "ThreadPuller",
      referer: "https://boards.4chan.org/#{board}/",
      accept: "image/webp,image/apng,image/*,*/*;q=0.8",
      connection: "keep-alive"
    }
  end

  defp get_fetch_headers(board) do
    board
    |> headers()
    |> Enum.into([])
    |> Enum.map(fn {k, v} -> {Atom.to_string(k), v} end)
  end
end
