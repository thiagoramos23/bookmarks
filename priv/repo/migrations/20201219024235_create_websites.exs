defmodule Bookmarks.Repo.Migrations.CreateWebsites do
  use Ecto.Migration

  def change do
    create table(:websites) do
      add :url, :string
      add :name, :string
      add :logo_url, :string
      add :tags, :string
      add :is_favorite, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:websites, [:user_id])
  end
end
