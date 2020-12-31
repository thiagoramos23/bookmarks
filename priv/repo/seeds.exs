# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Bookmarks.Repo.insert!(%Bookmarks.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
params = %{email: "thiagoramos@gmail.com", password: "1234567891011"}
changeset = Bookmarks.Accounts.User.registration_changeset(%Bookmarks.Accounts.User{}, params)
user = Bookmarks.Repo.insert!(changeset)

github = %Bookmarks.Bookmark.Website{
  url: "https://github.com",
  logo_url: "https://github.githubassets.com/images/modules/open_graph/github-logo.png",
  name: "Github",
  tags: "development,git",
  user: user
}
Bookmarks.Repo.insert(github)

twitter = %Bookmarks.Bookmark.Website{
  url: "https://twitter.com",
  logo_url: "https://abs.twimg.com/responsive-web/client-web/icon-ios.b1fc7275.png",
  name: "Twitter",
  tags: "social network,twitter,micro blog",
  user: user
}
Bookmarks.Repo.insert(twitter)


params = %{email: "marcos@gmail.com", password: "1234567891011"}
changeset = Bookmarks.Accounts.User.registration_changeset(%Bookmarks.Accounts.User{}, params)
user = Bookmarks.Repo.insert!(changeset)

github = %Bookmarks.Bookmark.Website{
  url: "https://github.com",
  logo_url: "https://github.githubassets.com/images/modules/open_graph/github-logo.png",
  name: "Github",
  tags: "development,git",
  user: user
}
Bookmarks.Repo.insert(github)
