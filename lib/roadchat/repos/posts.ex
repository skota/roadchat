defmodule Roadchat.Repos.Posts do
  import Ecto.Query, warn: false
  alias Roadchat.Repo
  alias Roadchat.Schemas.{Post, Like, UserLikes}

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
  def create_user_like(user_id, post_id) do

  end

  # delete user like
  def delete_user_like(user_id, post_id) do
    # first find the user like
    user_like = Repo.get_by(UserLike, [user_id: user_id, post_id: post_id])
    Repo.delete(user_like)
  end

end
