defmodule ThreadWatcher.Handlers.ApiInfo do
  alias ThreadWatcherWeb.Router.Helpers

  @spec add_info(atom(), Plug.Conn.t()) :: map()
  def add_info(:info, conn), do: info(:info, conn)

  @spec add_info([map()], atom(), Plug.Conn.t()) :: [map()]
  def add_info(data, info_name, conn) do
    data
    |> Enum.map(fn datum ->
      datum
      |> put_in([:api], info(info_name, datum, conn))
    end)
  end

  defp info(:board, %{board: board}, conn) do
    %{
      boards_link: Helpers.api_url(conn, :boards),
      board_link: Helpers.api_url(conn, :board, board)
    }
  end

  defp info(:thread, %{board: board, thread: thread}, conn) do
    info(:board, %{board: board}, conn)
    |> Map.put(:thread_link, Helpers.api_url(conn, :thread, board, thread))
  end

  defp info(:info, _data, conn), do: info(:info, conn)

  defp info(_info, _data, _conn), do: %{}

  defp info(:info, conn), do: info(:thread, %{board: "%s", thread: "%d"}, conn)
end
