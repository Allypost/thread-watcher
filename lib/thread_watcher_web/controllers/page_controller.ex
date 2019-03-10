defmodule ThreadWatcherWeb.PageController do
  use ThreadWatcherWeb, :controller

  def boards(conn, _params) do
    render(conn, "boards.html")
  end

  def threads(conn, params) do
    render(conn, "threads.html", board: params["board"])
  end

  def posts(conn, params) do
    render(conn, "posts.html", board: params["board"], thread: params["thread"])
  end
end
