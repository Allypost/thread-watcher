defmodule ThreadWatcherWeb.PageController do
  use ThreadWatcherWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
