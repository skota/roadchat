defmodule Roadchat.Schemas.Sale do
  use Ecto.Schema
  import Ecto.Changeset
  alias Roadchat.Schemas.Sale

  @derive {Jason.Encoder,
        only: [:id, :user_id, :title, :description, :category, :item_img, :price, :promoted, :sale_start, :sale_end, :inserted_at]}

  @required_fields [
    :user_id,
    :title,
    :description,
    :category,
    :item_img,
    :price,
    :promoted,
    :sale_start
  ]

  @cast_fields [
    :user_id,
    :title,
    :description,
    :category,
    :item_img,
    :price,
    :promoted,
    :sale_start,
    :sale_end
  ]

  schema "sales" do
    field :user_id, :integer
    field :title, :string
    field :description, :string
    field :category, :string
    field :item_img, :string
    field :price, :integer
    field :promoted, :boolean
    field :sale_start, :date
    field :sale_end, :date
    timestamps(type: :utc_datetime)
  end

  def blank_changeset(%Sale{} = sale, attrs) do
    sale
    |> cast(attrs, @cast_fields)
  end

  def changeset(%Sale{} = sale, attrs) do
    sale
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
