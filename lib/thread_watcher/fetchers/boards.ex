defmodule ThreadWatcher.Fetchers.Boards do
  alias ThreadWatcher.Fetchers.Fetcher

  @spec fetch() :: {:error, String.t()} | {:ok, [map()]}
  def fetch() do
    api_url()
    |> Fetcher.fetch("Boards can't be fetched at this moment")
    |> parse_response()
  end

  defp api_url(), do: "https://a.4cdn.org/boards.json"

  defp parse_response({:error, reason}), do: {:error, reason}
  defp parse_response({:ok, data}), do: {:ok, parse_boards(data.boards)}

  defp parse_boards(boards) do
    boards
    |> Enum.map(&parse_board/1)
  end

  defp parse_board(board) do
    %{
      title: board.title,
      board: board.board,
      description: board.meta_description,
      nsfw: board.ws_board == 0
    }
  end
end
