defmodule ThreadWatcher.Handlers.PostInfo do
  alias ThreadWatcher.Handlers.FileInfo

  @spec parse(map(), String.t()) :: map()
  def parse(post, board) do
    %{
      id: post.no,
      board: board,
      thread: thread(post),
      posted: posted(post),
      body: %{
        title: Map.get(post, :sub, ""),
        poster: Map.get(post, :name, "Anonymous"),
        content: Map.get(post, :com, "")
      },
      meta: %{
        replies: Map.get(post, :replies, 0),
        replies_list: [],
        mentions_list: [],
        images: Map.get(post, :images, 0)
      },
      file: FileInfo.parse(post, board)
    }
  end

  @spec add_metadata([map()]) :: [map()]
  def add_metadata(posts) do
    posts
    |> Enum.map(fn post -> add_metadata(post, posts) end)
  end

  @spec add_metadata(map(), [map()]) :: map()
  def add_metadata(post, posts) do
    post
    |> add_mentions()
    |> add_replies(posts)
  end

  @spec get_mentions(map(), [map()]) :: [map()]
  def get_mentions(post, posts) do
    mentions = post.meta.mentions_list

    posts
    |> Enum.filter(fn p -> p.id in mentions end)
  end

  @spec get_replies(map(), [map()]) :: [map()]
  def get_replies(post, posts) do
    replies = post.meta.replies_list

    posts
    |> Enum.filter(fn p -> p.id in replies end)
  end

  defp add_replies(post, posts),
    do: put_in(post, [:meta, :replies_list], find_replies(post, posts))

  defp add_mentions(post),
    do: put_in(post, [:meta, :mentions_list], find_mentions(post))

  defp find_replies(post, posts) do
    mentions_post? = fn p -> String.contains?(p.body.content, "#p#{post.id}") end

    posts
    |> Enum.filter(fn p -> mentions_post?.(p) end)
    |> Enum.map(fn p -> p.id end)
  end

  defp find_mentions(post) do
    match_to_int = fn num ->
      num
      |> Enum.at(1)
      |> Integer.parse()
      |> elem(0)
    end

    ~r/#p([0-9]+)/
    |> Regex.scan(post.body.content)
    |> Enum.map(fn match -> match_to_int.(match) end)
  end

  defp posted(%{time: time}), do: DateTime.from_unix(time) |> posted_date()

  defp thread(post) do
    case Map.get(post, :resto) do
      0 ->
        post.no

      thread ->
        thread
    end
  end

  defp posted_date({:ok, date}), do: date
  defp posted_date(_), do: DateTime.utc_now()
end
