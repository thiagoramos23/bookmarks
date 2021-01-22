defmodule Bookmarks.BookmarkFixtures do
  @moduledoc """
  This module defines helpers to create 
  entities for Website model via the 
  `Bookmarks.Bookmark` context.
  """

  def bookmark_fixture(attrs \\ %{}) do
    {:ok, bookmark} =
      attrs
      |> Bookmarks.Bookmark.create_website

    bookmark
  end
end
