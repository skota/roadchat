# This file needs to exist in lib or lib_web folder as it needs to be compiled in
Postgrex.Types.define(
  Roadchat.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Jason
)
