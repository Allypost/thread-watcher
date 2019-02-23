defmodule ThreadWatcher.Handlers.FileInfo do
  @spec parse(map(), String.t()) :: map()
  def parse(post, board) do
    post
    |> parse_body(board)
  end

  defp parse_body(post, board) do
    case has_file?(post) do
      true ->
        %{
          id: post.tim,
          name: post.filename,
          board: board,
          filename: "#{post.tim}#{post.ext}",
          extension: String.trim_leading(post.ext, "."),
          dimensions: %{
            main: %{
              width: post.w,
              height: post.h
            },
            thumbnail: %{
              width: post.tn_w,
              height: post.tn_h
            }
          },
          size: post.fsize,
          md5: post.md5,
          meta: %{}
        }
        |> add_meta()

      false ->
        nil
    end
  end

  defp has_file?(post), do: Map.get(post, :tim) != nil

  defp add_meta(post) do
    meta = %{
      is_video: is_video?(post.extension),
      thumb_src: thumb_src(post),
      thumb_full_src: thumb_full_src(post),
      thumb_original_src: thumb_original_src(post),
      full_src: full_src(post),
      original_src: full_src(post, true)
    }

    %{post | meta: meta}
  end

  defp image_domain(), do: Application.get_env(:thread_watcher, :image_domain, "")

  defp thumb_src(%{board: board, id: id}),
    do: cache_url(%{board: board, filename: "#{id}s.jpg"})

  defp thumb_full_src(%{board: board, filename: filename, extension: extension}) do
    case is_video?(extension) do
      1 -> thumb_url(%{board: board, filename: filename})
      0 -> cache_url(%{board: board, filename: filename})
    end
  end

  defp thumb_original_src(file),
    do: file |> put_in([:filename], "#{file.id}s.jpg") |> full_src(true)

  defp full_src(file), do: cache_url(file)
  defp full_src(file, true), do: "https://i.4cdn.org/#{file.board}/#{file.filename}"

  defp get_file_type("jpg"), do: "image"
  defp get_file_type("jpeg"), do: "image"
  defp get_file_type("png"), do: "image"
  defp get_file_type("gif"), do: "image"
  defp get_file_type(_), do: "video"

  defp is_video?(extension), do: if(get_file_type(extension) == "video", do: 1, else: 0)

  defp cache_url(%{board: board, filename: filename}),
    do: "#{image_domain()}/i/#{board}/#{filename}"

  defp thumb_url(%{board: board, filename: filename}),
    do: "#{image_domain()}/thumb/#{board}/#{filename}.jpg"
end
