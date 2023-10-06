defmodule Roadchat.Repo.Migrations.EnablePostgisExtension do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"
    execute("SELECT AddGeometryColumn ('loggedin_users','current_position',4326,'POINT',2);")
    execute("CREATE INDEX test_geom_idx ON loggedin_users USING GIST (current_position);")
  end
end
