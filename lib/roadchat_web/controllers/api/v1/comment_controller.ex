defmodule RoadchatWeb.API.V1.CommentController do
  use RoadchatWeb, :controller

  # alias Ecto.Changeset
  alias Roadchat.UtilHelpers
  alias Roadchat.Repos.Comment

  def index(conn, %{"id" => id}) do
    comments = Comment.get_comments_by_postid(id)
    conn = conn |> put_status(200)
    json(conn, comments)
  end

  # create comment
  def create(conn, %{"comment" => params}) do
    case Comment.create_comment(params) do
      {:ok, comment} ->
        conn
        |> put_status(201)
        |> json(%{message: "created comment #{comment.id}"})

      {:error, changeset} ->
        IO.puts inspect changeset
        # errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
        {:error, errors} = UtilHelpers.return_errors(changeset)

        conn
        |> put_status(500)
        |> json(%{error: errors})

    end
  end
end
