defmodule Bookmarks.Bookmark.IconModifier do
  use Bookmarks.DataCase
  import Bookmarks.BookmarkFixtures
  
  describe "modify/1" do

    test "when there is an image it updates the bookmark" do
      bookmark = bookmark_fixture(%{name: "Test", url: "https://twitter.com")
    end
  end
end
