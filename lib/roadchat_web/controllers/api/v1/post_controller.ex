defmodule RoadchatWeb.API.V1.PostController do
  use RoadchatWeb, :controller

  # alias Ecto.Changeset
  alias Roadchat.Repos.Post
  alias Roadchat.{Repo, UtilHelpers, StateBucket}
  alias Roadchat.Schemas.Post

  import Ecto.Query

  # get posts
  # how to add pagination to send chunked results
  def index(conn, _params) do
    # query = from(p in Post, order_by: [desc: p.inserted_at, desc: p.id])

    query = from u in "posts",
        join: r in "users", on: u.user_id == r.id,
        order_by: [desc: u.inserted_at, desc: u.id ],
        select: %{post_id: u.id,
                  first_name: r.fname,
                  last_name: r.lname,
                  post_img: u.post_img,
                  avatar: r.avatar,
                  post: u.post,
                  created_at: u.inserted_at,
                  comment_count: u.comment_count,
                  like_count: u.like_count
                }

    Repo.paginate(query, cursor_fields: [:inserted_at, :id], limit: 10)
    %{entries: entries, metadata: metadata} = Repo.paginate(query, cursor_fields: [:inserted_at, :id], limit: 5)

    #   save metadata.after to agent
    # cursor_before = metadata.after
    StateBucket.put(:state_bucket, "metadata_before", metadata.before)

    # NOTE: add comment count and like count fields to post?
    # add triggers to likes - increment post.like_count in posts for new like
    # add triggers to likes - decrement post.like_count in posts for new like

    # add triggers to comments - increment post.comment_count in posts for new like
    # posts = Post.list_posts()
    IO.inspect entries

    conn
    |> put_status(200)
    |> json(entries)
  end

  def refresh(conn, _params) do
    cursor_before = StateBucket.get(:state_bucket, "metadata_before")

    query = from u in "posts",
        join: r in "users", on: u.user_id == r.id,
        order_by: [desc: u.inserted_at, desc: u.id],
        select: %{post_id: u.id,
                  first_name: r.fname,
                  last_name: r.lname,
                  post_img: u.post_img,
                  avatar: r.avatar,
                  post: u.post,
                  created_at: u.inserted_at,
                  comment_count: u.comment_count,
                  like_count: u.like_count
                }

    # query = from(p in Post, order_by: [asc: p.inserted_at, asc: p.id])

    Repo.paginate(query, cursor_fields: [:inserted_at,:id], limit: 20)
    %{entries: entries, metadata: metadata} = Repo.paginate(query, before: cursor_before, cursor_fields: [:inserted_at, :id], limit: 20)

    # IO.inspect entries
    StateBucket.put(:state_bucket, "metadata_before", metadata.before)

    conn
    |> put_status(200)
    |> json(entries)
  end

  # create post
  def create(conn, %{"post" => params}) do
    post_params = %{
      "post" => params["post_body"],
      "user_id" => params["user_id"],
      "post_img" => params["post_img"],
    }

    case Roadchat.Repos.Post.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_status(200)
        |> json(%{message: "created post #{post.id}"})

      {:error, changeset} ->
        IO.puts inspect changeset
        # errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
        {:error, errors} = UtilHelpers.return_errors(changeset)

        conn
        |> put_status(500)
        |> json(%{error: errors})

    end
  end

  def comment_count(conn, %{"post" => params}) do

    IO.puts "inside post controller: comment_count"
    post = Repo.get(Post,params["id"])
    comment_count = post.comment_count + 1

    Post.update_changeset(post, %{comment_count: comment_count})
    |> Repo.update()

    conn
    |> put_status(200)
    |> json(%{ok: "updated comment count"})
  end

  def like_post(conn, %{"post" => params}) do
    post = Repo.get(Post,params["id"])
    like_count = post.like_count + 1

    Post.update_changeset(post, %{like_count: like_count})
    |> Repo.update()

    conn
    |> put_status(200)
    |> json(%{ok: "Incremented like"})
  end

  def unlike_post(conn, %{"post" => params}) do
    post = Repo.get(Post,params["id"])

    like_count = if post.like_count == 0 do
      0
    else
      post.like_count - 1
    end

    Post.update_changeset(post, %{like_count: like_count})
    |> Repo.update()

    conn
    |> put_status(200)
    |> json(%{ok: "Decremented like"})
  end

end
