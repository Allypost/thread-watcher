defmodule ThreadWatcher.Fetchers.Thread do
  alias ThreadWatcher.Fetchers.Fetcher
  alias ThreadWatcher.Handlers.PostInfo

  @spec fetch(String.t(), number()) :: {:error, String.t()} | {:ok, [map()]}
  def fetch(board, thread) do
    api_url(board, thread)
    |> Fetcher.fetch("Thread can't be fetched at this moment")
    |> parse_response(board)
  end

  defp api_url(board, thread), do: "https://a.4cdn.org/#{board}/thread/#{thread}.json"

  defp parse_response({:error, reason}, _), do: {:error, reason}
  defp parse_response({:ok, thread}, board), do: {:ok, parse_thread(thread, board)}

  defp parse_thread(%{posts: posts}, board) do
    posts
    |> Enum.map(fn post -> PostInfo.parse(post, board) end)
  end
end
