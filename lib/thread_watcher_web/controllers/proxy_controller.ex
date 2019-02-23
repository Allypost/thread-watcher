defmodule ThreadWatcherWeb.ProxyController do
  use ThreadWatcherWeb, :controller

  @spec image(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def image(conn, %{"board" => board, "file" => file}) do
    case ThreadWatcher.Fetchers.Asset.fetch(board, file) do
      {:ok, data, headers} ->
        conn
        |> merge_resp_headers(headers)
        |> send_resp(200, data)

      {:error, reason} ->
        conn
        |> json(reason)
    end
  end

  @spec thumb(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def thumb(conn, %{"board" => board, "file" => file}) do
    case ThreadWatcher.Fetchers.Thumb.fetch(board, file) do
      {:ok, data, headers} ->
        conn
        |> merge_resp_headers(headers)
        |> send_resp(200, data)

      {:error, reason} ->
        conn
        |> json(reason)
    end
  end
end
