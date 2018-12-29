defmodule ThreadWatcherWeb.Router do
  use ThreadWatcherWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ThreadWatcherWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/v1", ThreadWatcherWeb do
    pipe_through :api

    get "/", ApiController, :info
    get "/boards", ApiController, :boards
    get "/boards/:board", ApiController, :board
    get "/boards/:board/thread/:thread", ApiController, :thread
  end

  scope "/api", ThreadWatcherWeb, as: :api_redirect do
    pipe_through :api

    get "/", Redirect, to: "/api/v1"
  end

  # Other scopes may use custom stacks.
  # scope "/api", ThreadWatcherWeb do
  #   pipe_through :api
  # end
end

defmodule ThreadWatcherWeb.Redirect do
  use ThreadWatcherWeb, :router

  def init(opts), do: opts

  def call(conn, opts) do
    conn
    |> Phoenix.Controller.redirect(opts)
    |> halt()
  end
end
