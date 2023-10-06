defmodule Roadchat.Repos.LoggedinUsers do
  import Ecto.Query, warn: false
  alias Roadchat.Repo
  alias Roadchat.Schemas.LoggedinUser

  def create_loggedin_user(attrs \\ %{}) do
    %LoggedinUser{}
    |> LoggedinUser.changeset(attrs)
    |> Repo.insert!()
  end

  def get_loggedin_user(id), do: Repo.get_by(LoggedinUser, [user_id: id])


  def update_loggedin_user(%LoggedinUser{} = user, attrs) do
    user
    |> LoggedinUser.changeset(attrs)
    |> Repo.update()
  end


  def get_users_in_range(id) do
    # pass in current userid and range

    query = "select a.user_id,
                    u.fname,
                    u.lname,
                    u.email,
                    u.fb_user_id,
                    u.avatar,
                    u.fb_password,
                    ST_Distance(a.current_position, hr_jax.current_position, true) as distance
          from loggedin_users a,
          lateral (
            select user_id, current_position from loggedin_users where user_id = $1
          ) as hr_jax, users u
          where a.user_id <> hr_jax.user_id and
            a.user_id = u.id and
            ST_Distance(a.current_position, hr_jax.current_position, true) < 25000 and
            a.logged_in = true
          order by distance;"

          # query = "select a.user_id,
          #           u.fname,
          #           u.lname,
          #           u.email,
          #           u.fb_user_id,
          #           u.avatar,
          #           u.fb_password,
          #           ST_Distance(a.current_position, hr_jax.current_position, true) as distance
          # from loggedin_users a,
          # lateral (
          #   select user_id, current_position from loggedin_users where user_id = $1
          # ) as hr_jax, users u
          # where a.user_id <> hr_jax.user_id and
          #   a.user_id = u.id and
          #   a.logged_in = true
          # order by distance;"

    Ecto.Adapters.SQL.query!(Repo, query, [id])

  end

  def sql_magic(result) do
    columns = result.columns |> Enum.map(&(String.to_atom(&1)))
    dlist = Enum.map result.rows, fn(row) ->
      Enum.zip(columns, row) |> Map.new
    end

    IO.inspect dlist

    dlist
    # for item <- dlist do
    #   IO.inspect item
    # end
  end



end
