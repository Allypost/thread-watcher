defmodule ThreadWatcher.Fetchers.Thumb do
  alias ThreadWatcher.Handlers.Fetcher

  @spec fetch(String.t(), String.t()) :: Fetcher.error() | Fetcher.resp_raw()
  def fetch(board, file) do
    board
    |> ThreadWatcher.Fetchers.Asset.fetch(thumb_file(file))
  end

  defp is_thumb?(file), do: file |> Path.rootname() |> String.ends_with?("s")

  defp thumb_file(file), do: file |> is_thumb?() |> thumb_file(file)
  defp thumb_file(true, file), do: file |> Path.rootname() |> Kernel.<>(".jpg")
  defp thumb_file(false, file), do: file |> Path.rootname() |> Kernel.<>("s.jpg")
end
