defmodule ThreadWatcherWeb.PageController do
  use ThreadWatcherWeb, :controller

  def boards(conn, _params) do
    {:ok, boards} = ThreadWatcher.fetch()
    render(conn, "boards.html", boards: boards)
  end

  def threads(conn, params) do
    {:ok, threads} = ThreadWatcher.fetch(params["board"])
    render(conn, "threads.html", board: params["board"], threads: threads)
  end

  def posts(conn, params) do
    {:ok, posts} = ThreadWatcher.fetch(params["board"], params["thread"])
    render(conn, "posts.html", board: params["board"], thread: params["thread"], posts: posts)
  end
end
