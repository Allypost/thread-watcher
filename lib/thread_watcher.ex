defmodule ThreadWatcher do
  @moduledoc """
  ThreadWatcher keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias ThreadWatcher.Fetchers

  @spec fetch() :: {:error, binary()} | {:ok, [map()]}
  def fetch(), do: Fetchers.Boards.fetch()

  @spec fetch(binary()) :: {:error, binary()} | {:ok, [map()]}
  def fetch(board), do: Fetchers.Board.fetch(board)

  @spec fetch(binary(), number()) :: {:error, binary()} | {:ok, [map()]}
  def fetch(board, thread), do: Fetchers.Thread.fetch(board, thread)
end
