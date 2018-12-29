defmodule ThreadWatcherWeb.ApiController do
  alias ThreadWatcher.Handlers.ApiInfo
  use ThreadWatcherWeb, :controller

  @spec info(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def info(conn, _params) do
    conn
    |> default_json(:info)
  end

  @spec boards(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def boards(conn, _params) do
    ThreadWatcher.fetch()
    |> default_json(conn, :board)
  end

  @spec board(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def board(conn, %{"board" => board}) do
    ThreadWatcher.fetch(board)
    |> default_json(conn, :thread)
  end

  @spec thread(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def thread(conn, %{"board" => board, "thread" => thread}) do
    ThreadWatcher.fetch(board, thread)
    |> default_json(conn, :thread)
  end

  defp default_json(conn, info), do: json(conn, add_api_info(conn, info))

  defp default_json(fetch_result, conn, info) do
    case fetch_result do
      {:ok, data} ->
        conn
        |> json(%{success: true, data: add_api_info(data, conn, info)})

      {:error, reason} ->
        conn
        |> put_status(:not_found)
        |> json(%{success: false, error: reason})
    end
  end

  defp add_api_info(conn, info),
    do: ApiInfo.add_info(info, conn)

  defp add_api_info(data, conn, info),
    do: ApiInfo.add_info(data, info, conn)
end
