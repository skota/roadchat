defmodule RoadchatWeb.API.V1.PostController do
  use RoadchatWeb, :controller

  alias Roadchat.Repos.Posts
  alias Roadchat.{Repo, UtilHelpers, StateBucket}
  # alias Roadchat.Schemas.Post

  import Ecto.Query

  # get posts
  # how to add pagination to send chunked results
  def index(conn, _params) do
    # TODO: why is this here..this code should be in elixir module...no data logic in controllers
    # add new field user liked post, default true
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


    # Repo.paginate(query, cursor_fields: [:inserted_at, :id], limit: 10)
    %{entries: entries, metadata: metadata} = Repo.paginate(query, cursor_fields: [:inserted_at, :id], limit: 5)
    #   save metadata.after to agent
    # cursor_before = metadata.after
    StateBucket.put(:state_bucket, "metadata_before", metadata.before)

    conn
    |> put_status(200)
    |> json(entries)
  end


  def get_post_likes(conn, %{"post_id" => post_id}) do
    # get data from likes table
    likes = Posts.get_post_likes(post_id)

    conn
    |> put_status(200)
    |> json(likes)
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

    case  Posts.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_status(201)
        |> json(%{message: "created post #{post.id}"})

      {:error, changeset} ->
        IO.puts inspect changeset
        # errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
        {:error, errors} = UtilHelpers.return_errors(changeset)

        # TODO: why return 500?
        conn
        |> put_status(500)
        |> json(%{error: errors})

    end
  end

  # get post
  def get_post(conn, %{"id" => post_id}) do
    {id, ""} = Integer.parse(post_id)

    post = Posts.get_post(id)

    conn
    |> put_status(200)
    |> json(post)

  end

  def comment_count(conn, %{"post" => params}) do
    IO.puts "inside post controller: comment_count"
    post = Repo.get(Post,params["id"])
    comment_count = post.comment_count + 1

    # wrong
    # call repo function to update post, pass in attr
    # Post.update_changeset(post, %{comment_count: comment_count})
    # |> Repo.update()

    case  Posts.update_post(post, %{comment_count: comment_count}) do
      {:ok, _post} ->
        conn
        |> put_status(200)
        |> json(%{ok: "updated comment count"})
      {:error, changeset} ->
        # https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#2xx_Success
        conn
        |> put_status(202)
        |> json(%{ok: "Unable to  update comment count"})
    end
  end


  # TODO: post params will contain  post_id and user_id
  # insert into user_likes - post_id, user_id
  def like_post(conn, %{"post" => params}) do
    IO.inspect params
    post = Posts.get_single_post(params["id"])
    like_count = post.like_count + 1

    # todo: create new table user_likes
    # start a transsaction
    # update_post (like count)
    # insert new row into likes
    case  Posts.update_post(post, %{like_count: like_count}) do
      {:ok, _post} ->
        # insert into user_likes - user_id and post_id


          conn
          |> put_status(200)
          |> json(%{ok: "updated like count"})
      {:error, changeset} ->
        # https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#2xx_Success
        conn
          |> put_status(202)
          |> json(%{ok: "Unable to  update like count"})
    end
  end


  # TODO: post params will contain  post_id and user_id
  # delete from  user_likes - post_id, user_id
  def unlike_post(conn, %{"post" => params}) do
    IO.inspect params
    post = Posts.get_single_post(params["id"])

    like_count = if post.like_count == 0 do
      0
    else
      post.like_count - 1
    end

    case  Posts.update_post(post, %{like_count: like_count}) do
      {:ok, _post} ->
          conn
          |> put_status(200)
          |> json(%{ok: "updated like count"})
      {:error, changeset} ->
        # https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#2xx_Success
        conn
          |> put_status(202)
          |> json(%{ok: "Unable to  update like count"})
    end
  end

  # get user liked posts
  def get_post_likes(conn, %{"user_id" => id}) do
    {user_id, ""} = Integer.parse(id)

    user_likes = Posts.get_user_likes(id)
    conn
    |> put_status(200)
    |> json(user_likes)
  end

end
