defmodule Roadchat.Repos.GeoLocation do
  alias Roadchat.Repo
  import Ecto.Query
  alias Roadchat.Schemas.UserLocation
  alias Roadchat.Servers.UserStateServer

  # get current user geo location from user_location
  def get_location_by_user(user_id) do
    Repo.get_by(UserLocation, [user_id: user_id])
  end

  def create_user_location(attrs) do
    %UserLocation{}
    |> UserLocation.changeset(attrs)
    |> Repo.insert!()
  end

  def update_user_location(location, attrs) do
    location
    |> UserLocation.changeset(attrs)
    |> Repo.update!()
  end

  def get_distance_between_points() do
    id = UserStateServer.get_user()
    match_ids = UserStateServer.get_chat_list()

    if !is_nil(id) && Enum.count(match_ids) > 0 do
      query = "select
                a.user_id,
                ST_Distance(a.geom, hr_jax.geom, true) as distance
            from user_location a,
            lateral (
              select user_id, geom from user_location where user_id = $1
            ) as hr_jax
            where
              a.user_id <> hr_jax.user_id and
              a.user_id= ANY($2) and
              ST_Distance(a.geom, hr_jax.geom, true) <= 2000
            order by distance;"

      results = Ecto.Adapters.SQL.query!(Repo, query, [id, match_ids])

      Enum.map(results.rows, fn result ->
        [id, distance]  = result
        %{"id" => id, "distance" => distance}
      end)

    # next filter items where distance = 0
    # lastly send notification
    
    end
  end

  # get list of users contacts
  def get_user_contacts_for_chat() do
    # 2 - read the user from genserver
    user_id = UserStateServer.get_user()
    # joining users and recent_chats gives us - users chat contacts
    # joining with user_locations enables us to find distances between user and user contatcs
    query = from c in "recent_chats",
            join: u in "users", on: c.chat_with_user_id == u.id,
            where: c.user_id == ^user_id,
            select: u.id
    Repo.all(query)
  end


  # get user location records older than 5 mins
  # call this from genserver
  def expire_location_records() do
    now =  NaiveDateTime.local_now()

    query = from u in "user_location",
            where: fragment(
                "extract(epoch from ? - ?) / 60  >=  5",
                ^now,
                u.inserted_at),
            select: %{"id" => u.id}

    Repo.delete_all(query)
  end
end
