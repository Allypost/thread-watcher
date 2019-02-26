defmodule ThreadWatcherWeb.LayoutView do
  use ThreadWatcherWeb, :view

  def global_js_data(conn) do
    %{
      config: %{
        api_url: Application.get_env(:thread_watcher, :api_domain, "/api"),
        api_urls: ThreadWatcher.Handlers.ApiInfo.add_info(:info, conn)
      }
    }
  end
end
