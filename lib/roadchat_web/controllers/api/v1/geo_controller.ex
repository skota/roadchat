defmodule RoadchatWeb.API.V1.GeoController do
  use RoadchatWeb, :controller
  alias Roadchat.Repos.GeoLocation

  def manage_geo_pos(conn, %{"geo_params" => params}) do

    # %Geo.Point{coordinates: {30, -90}, srid: 4326}
    geo = %Geo.Point{coordinates: {params["lon"], params["lat"]}, srid: 4326}
    now =  NaiveDateTime.local_now()
    case GeoLocation.get_location_by_user(params["user_id"]) do
      nil ->
        GeoLocation.create_user_location(%{user_id: params["user_id"],
                  geom: geo, inserted_at: now })
        conn
          |> put_status(200)
          |> json(%{ok: "inserted Geo"})
      location ->
        GeoLocation.update_user_location(location, %{geom: geo, inserted_at: now})

        conn
          |> put_status(200)
          |> json(%{ok: "updated Geo"})
      end


  end

end
