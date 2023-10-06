defmodule Roadchat.Repos.Post do
  import Ecto.Query, warn: false
  alias Roadchat.Repo
  alias Roadchat.Schemas.Post

  def build_post(attrs \\ %{}) do
    %Post{}
    |> Post.blank_changeset(attrs)
  end

  @spec create_post(:invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}) ::
          any
  def create_post(attrs \\ %{}) do
    IO.puts "inside repo: create post"
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  # get single post
  def get_post!(id), do: Repo.get!(Post, id)

  # get posts
  def list_posts do
    Repo.all(Post)
  end

  # def update_patient(%Patient{} = patient, test_params) do
  #   patient
  #   |> Patient.update_changeset(test_params)
  #   |> Repo.update()
  # end

  # def get_patient_by_phone(phone), do: Repo.get_by(Patient, phone_number: phone)

  # def get_patient_by_email(email), do: Repo.get_by(Patient, email: email)

  # # delete patient
  # def delete_patient(%Patient{} = patient) do
  #   Repo.delete(patient)
  # end

end
