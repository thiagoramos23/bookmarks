defmodule Bookmarks.Bookmark do
  @moduledoc """
  The Bookmark context.
  """

  import Ecto.Query, warn: false
  alias Bookmarks.Repo

  alias Bookmarks.Bookmark.Website

  @doc """
  Returns the list of websites.

  ## Examples

      iex> list_websites()
      [%Website{}, ...]

  """
  def list_websites(attrs \\ %{}) do
    case attrs do
      %{user: user} ->
        {:ok, query} = Website.all_websites_by_user_query(user)

        Repo.all(query)
        |> Repo.preload(:user)

      _ ->
        Repo.all(Website)
        |> Repo.preload(:user)
    end
  end

  @doc """
  Returns a list of websites by user and the param passed.
  The param passed will search for like in name and url columns

  ## Examples

      iex> list_websites(%{user: user, param: "Twi"})
      [%Website{name: "Twitter"}, %Website{:url: "http://twitter.com"}...]
  """
  def list_websites_by(%{user_id: user_id, param: param}) do
    attribute_param = "%#{param}%"

    query =
      from w in Website,
        where:
          w.user_id == ^user_id and
            (ilike(w.name, ^attribute_param) or ilike(w.url, ^attribute_param))

    Repo.all(query)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single website.

  Raises `Ecto.NoResultsError` if the Website does not exist.

  ## Examples

      iex> get_website!(123)
      %Website{}

      iex> get_website!(456)
      ** (Ecto.NoResultsError)

  """
  def get_website!(id), do: Repo.get!(Website, id) |> Repo.preload(:user)

  @doc """
  Creates a website.

  ## Examples

      iex> create_website(%{field: value})
      {:ok, %Website{}}

      iex> create_website(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_website(attrs \\ %{}) do
    %Website{}
    |> Website.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a website.

  ## Examples

      iex> update_website(website, %{field: new_value})
      {:ok, %Website{}}

      iex> update_website(website, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_website(%Website{} = website, attrs) do
    website
    |> Website.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a website.

  ## Examples

      iex> delete_website(website)
      {:ok, %Website{}}

      iex> delete_website(website)
      {:error, %Ecto.Changeset{}}

  """
  def delete_website(%Website{} = website) do
    Repo.delete(website)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking website changes.

  ## Examples

      iex> change_website(website)
      %Ecto.Changeset{data: %Website{}}

  """
  def change_website(%Website{} = website, attrs \\ %{}) do
    Website.changeset(website, attrs)
  end
end
