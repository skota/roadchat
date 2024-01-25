defmodule Roadchat.Repos.Posts do
  import Ecto.Query, warn: false
  alias Roadchat.Repo
  alias Roadchat.Schemas.{Post, Like, UserLikes, PostWithLikes}

  def build_post(attrs \\ %{}) do
    %Post{}
    |> Post.blank_changeset(attrs)
  end

  @spec create_post(:invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          any
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def get_single_post(id) do
    Repo.get(Post, id)
  end

  # get single post
  def get_post(id) do
    query = from u in "posts",
        join: r in "users", on: u.user_id == r.id,
        where: u.id == ^id,
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
      Repo.one(query)
  end

  # get posts
  def list_posts do
    # TODO: this approach wont scale with 1000's of posts and likes
    # will need to rearchitect this
    Repo.all(Post)
  end

  # get all posts with current user likes
  def get_posts_with_likes() do
    # fetch 100 most recent rows

    qry = "select
        p.id,
        p.post,
        p.post_img,
        u.avatar,
        p.user_id,
        (select count(*) > 0 from user_likes ul where ul.post_id = p.id and ul.user_id = p.user_id) as user_liked_post,
        p.comment_count,
        p.like_count,
        u.fname,
        u.lname
    from
      posts p, users u
    where p.user_id = u.id
    order by p.inserted_at desc
    Limit 50"

    # 1 - check if there is a row offset in genserver
    # 2- build raw sql using offset from 1
    # 3- fetch rows and send to APP
    #4 - update genserver with current row offset

    result = Ecto.Adapters.SQL.query!(Roadchat.Repo, qry, [])

    Enum.map(result.rows, fn x ->
      %{ "id" => Enum.at(x,0),
          "post" => Enum.at(x,1),
          "post_img" => Enum.at(x,2),
          "avatar" => Enum.at(x,3),
          "user_id" => Enum.at(x,4),
          "user_liked_post" => Enum.at(x,5),
          "comment_count" => Enum.at(x,6),
          "like_count" => Enum.at(x,7),
          "first_name" => Enum.at(x,8),
          "last_name" => Enum.at(x,9)
       }
    end)
  end


  def get_user_likes(user_id) do
    Repo.all(UserLikes, [user_id: user_id])
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.update_changeset(attrs)
    |> Repo.update()
  end

  def get_post_likes() do
    Repo.all(Like)
  end

  # create user like
  def create_user_like(attrs) do
    %UserLikes{}
    |> UserLikes.changeset(attrs)
    |> Repo.insert()
  end

  # delete user like
  def delete_user_like(user_like_id) do
    # first find the user like
    user_like = Repo.get(UserLikes, user_like_id)
    Repo.delete(user_like)
  end

  def get_user_like(user_id, post_id) do
    Repo.get_by(UserLikes, [user_id: user_id, post_id: post_id])
  end

  def like_or_unlike_post(user_id, post_id) do
    # 1. check if there is a row in user_likes
    user_like = get_user_like(user_id, post_id)
    post = get_single_post(post_id)

    if is_nil(user_like) do
      # increment like count in post
      like_count = post.like_count + 1
      user_likes = %{"user_id" => user_id, "post_id" => post_id}
      increment(post, like_count, user_likes)
    else
      # decrement like count in post, delete user_like where (user-id, post_id)
      like_count = post.like_count - 1
      # user_likes = %{"user_id" => user_id, "post_ud" => post_id}
      decrement(post, like_count, user_like.id)
    end
  end

  def increment(post, like_count, user_likes) do
    case  update_post(post, %{like_count: like_count}) do
      {:ok, _post} ->
        create_user_like(user_likes)
        {:ok, 200}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def decrement( post, like_count, user_like_id) do
    case  update_post(post, %{like_count: like_count}) do
      {:ok, _post} ->
        delete_user_like(user_like_id)
        {:ok, 200}
      {:error, changeset} ->
        {:error, changeset}
    end
  end



end
