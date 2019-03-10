defmodule ThreadWatcherWeb.PageController do
  use ThreadWatcherWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def board(conn, params) do
    render(conn, "board.html", board: params["board"])
  end

  def thread(conn, params) do
    render(conn, "thread.html", board: params["board"], thread: params["thread"])
  end
end
