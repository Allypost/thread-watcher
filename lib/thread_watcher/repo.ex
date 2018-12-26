defmodule ThreadWatcher.Repo do
  use Ecto.Repo,
    otp_app: :thread_watcher,
    adapter: Ecto.Adapters.Postgres
end
