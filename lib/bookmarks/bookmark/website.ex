defmodule Bookmarks.Bookmark.Website do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Bookmarks.Accounts.User
  alias Bookmarks.Bookmark.Website

  schema "websites" do
    field :is_favorite, :boolean, default: false
    field :logo_url, :string
    field :name, :string
    field :tags, :string
    field :url, :string
    belongs_to :user, Bookmarks.Accounts.User

    timestamps()
  end

  @doc false
  def all_websites_by_user_query(user) do
    query =
      from w in Website,
        where: w.user_id == ^user.id

    {:ok, query}
  end

  @doc false
  def changeset(website, attrs) do
    changes = website
    |> cast(attrs, [:url, :name, :logo_url, :tags, :is_favorite])
    |> validate_required([:url, :name])

    case Map.get(attrs, :user) do
      %User{} ->
        changes
        |> put_assoc(:user, attrs.user)
      _ ->
        changes
    end
  end

end
