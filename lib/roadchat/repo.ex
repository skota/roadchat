defmodule Roadchat.Repo do
  use Ecto.Repo,
    otp_app: :roadchat,
    adapter: Ecto.Adapters.Postgres

    use Paginator


    def execute_and_load(sql, params, model) do
      Ecto.Adapters.SQL.query!(__MODULE__, sql, params)
      |> load_into(model)
    end

    defp load_into(response, model) do
      Enum.map response.rows, fn(row) ->
        fields = Enum.reduce(Enum.zip(response.columns, row), %{}, fn({key, value}, map) ->
          Map.put(map, key, value)
        end)

        __MODULE__.load(model, fields)
      end
    end
end
