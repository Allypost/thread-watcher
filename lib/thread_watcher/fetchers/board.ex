defmodule ThreadWatcher.Fetchers.Board do
  alias ThreadWatcher.Handlers.Fetcher
  alias ThreadWatcher.Handlers.PostInfo

  @spec fetch(String.t()) :: {:error, String.t()} | {:ok, [map()]}
  def fetch(board) do
    api_url(board)
    |> Fetcher.fetch("Board can't be fetched at this moment")
    |> parse_response(board)
  end

  defp api_url(board), do: "https://a.4cdn.org/#{board}/catalog.json"

  defp parse_response({:error, reason}, _), do: {:error, reason}
  defp parse_response({:ok, pages}, board), do: {:ok, parse_pages(pages, board)}

  defp parse_pages(pages, board) do
    pages
    |> Enum.flat_map(fn page -> parse_page(page, board) end)
    |> PostInfo.add_metadata()
  end

  defp parse_page(%{threads: threads}, board) do
    threads
    |> Enum.map(fn thread -> PostInfo.parse(thread, board) end)
  end
end
