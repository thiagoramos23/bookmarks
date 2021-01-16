defmodule Bookmarks.BookmarkTest do
  use Bookmarks.DataCase

  alias Bookmarks.Bookmark
  alias Bookmarks.Accounts.User
  alias Bookmarks.Repo
  import Bookmarks.AccountsFixtures

  setup do
    user = user_fixture(%{email: "thiagoramos@gmail.com"})
    {:ok, %{user: user}}
  end

  describe "websites" do
    alias Bookmarks.Bookmark.Website

    @valid_attrs %{
      is_favorite: true,
      logo_url: "some logo_url",
      name: "some name",
      tags: "some tags",
      url: "http://twitter.com"
    }
    @update_attrs %{
      is_favorite: false,
      logo_url: "some updated logo_url",
      name: "some updated name",
      tags: "some updated tags",
      url: "http://facebook.com"
    }
    @invalid_attrs %{is_favorite: nil, logo_url: nil, name: nil, tags: nil, url: nil}
    @invalid_url_attrs %{
      is_favorite: false,
      logo_url: "http://logo.com",
      name: "Invalid",
      tags: "invalid",
      url: "invalid_url"
    }

    def website_fixture(attrs \\ %{}) do
      {:ok, website} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bookmark.create_website()

      website
    end

    test "list_websites/0 returns all websites", %{user: user} do
      other_user = user_fixture(%{email: "carlos@gmail.com"})
      website = website_fixture(%{user: user})
      other_user_website = website_fixture(%{user: other_user})

      assert Bookmark.list_websites() == [website, other_user_website]
      assert Bookmark.list_websites(%{user: user}) == [website]
    end

    test "list_websites/1 returns all websites by name or url", %{user: user} do
      website = website_fixture(%{user: user, name: "Twitter"})

      other_website =
        website_fixture(%{user: user, name: "My Castle", url: "https://twitter.com"})

      assert Bookmark.list_websites_by(%{user_id: user.id, param: "Twi"}) == [
               website,
               other_website
             ]
    end

    test "get_website!/1 returns the website with given id", %{user: user} do
      website = website_fixture(%{user: user})
      website = Repo.get(Website, website.id)
      assert Bookmark.get_website!(website.id) == website
    end

    test "create_website/1 with valid data creates a website", %{user: user} do
      assert {:ok, %Website{} = website} =
               Bookmark.create_website(%{user: user} |> Enum.into(@valid_attrs))

      assert website.is_favorite == true
      assert website.logo_url == "some logo_url"
      assert website.name == "some name"
      assert website.tags == "some tags"
      assert website.url == "http://twitter.com"
    end

    test "create_website/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} =
               Bookmark.create_website(%{user: user} |> Enum.into(@invalid_attrs))
    end

    test "create_website/1 with invalid url returns an error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{} = changeset} =
               Bookmark.create_website(%{user: user} |> Enum.into(@invalid_url_attrs))

      assert [url: {"Invalid URL", []}] = changeset.errors
    end

    test "update_website/2 with valid data updates the website", %{user: user} do
      website = website_fixture(%{user: user})

      assert {:ok, %Website{} = website} =
               Bookmark.update_website(website, %{user: user} |> Enum.into(@update_attrs))

      assert website.is_favorite == false
      assert website.logo_url == "some updated logo_url"
      assert website.name == "some updated name"
      assert website.tags == "some updated tags"
      assert website.url == "http://facebook.com"
    end

    test "update_website/2 with invalid data returns error changeset", %{user: user} do
      website = website_fixture(%{user: user})
      assert {:error, %Ecto.Changeset{}} = Bookmark.update_website(website, @invalid_attrs)

      website = Repo.get(Website, website.id)
      assert website == Bookmark.get_website!(website.id)
    end

    test "delete_website/1 deletes the website", %{user: user} do
      website = website_fixture(%{user: user})
      assert {:ok, %Website{}} = Bookmark.delete_website(website)
      assert_raise Ecto.NoResultsError, fn -> Bookmark.get_website!(website.id) end
    end

    test "change_website/1 returns a website changeset", %{user: user} do
      website = website_fixture(%{user: user})
      assert %Ecto.Changeset{} = Bookmark.change_website(website)
    end
  end
end
