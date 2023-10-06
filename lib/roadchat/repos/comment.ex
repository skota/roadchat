defmodule Roadchat.Repos.Comment do
  import Ecto.Query, warn: false
  alias Roadchat.Repo
  alias Roadchat.Schemas.Comment

  def build_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.blank_changeset(attrs)
  end

  @spec create_comment(:invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          any
  def create_comment(attrs \\ %{}) do
    IO.puts "inside repo: create comment"
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

   # get single comment
   def get_comment!(id), do: Repo.get!(Comment, id)


   def get_comments_by_postid(id)do

    post_id = String.to_integer(id)

    query = from c in "comments",
            where: c.post_id == ^post_id,
            select: %{
              id: c.id,
              post_id: c.post_id,
              user_id: c.user_id,
              comment: c.comment,
              inserted_at: c.inserted_at,
              avatar: c.avatar
            }
     Repo.all(query)
   end

   # get comments by postid
   def list_comments(postid) do
     Repo.get_by(Comment, [post_id: postid] )
   end
end
