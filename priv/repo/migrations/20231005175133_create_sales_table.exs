defmodule Roadchat.Repo.Migrations.CreateSalesTable do
  use Ecto.Migration

  def change do
    create table(:sales) do
      add :user_id, :integer, null: false
      add :description, :text, null: false
      add :category, :text, null: false
      add :item_img, :text, null: false
      add :price, :integer, null: false
      add :promoted, :boolean, default: false
      add :sale_start, :date, null: false
      add :sale_end, :date, null: true
      add :title, :string, null: false, default: "sale"

      timestamps()
  end
  end
end
