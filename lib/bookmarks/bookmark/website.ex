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
    changes =
      website
      |> cast(attrs, [:url, :name, :logo_url, :tags, :is_favorite])
      |> validate_required([:url, :name])
      |> validate_uri_is_valid(:url)

    case Map.get(attrs, :user) do
      %User{} ->
        changes
        |> put_assoc(:user, attrs.user)

      _ ->
        changes
    end
  end

  defp validate_uri_is_valid(%Ecto.Changeset{} = changeset, field) when not is_nil(field) do
    validate_change(changeset, field, fn current_field, value ->
      uri = URI.parse(value)
      case uri do
        %URI{scheme: nil} ->
          [{current_field, "Invalid URL"}]
        %URI{host: nil} ->
          [{current_field, "Invalid URL"}]
        uri ->
          case :inet.gethostbyname(to_charlist(uri.host)) do
            {:error, _} ->
              [{current_field, "Invalid URL"}]
            {:ok, _} -> []
          end
      end
    end)
  end
end
