defmodule Bookmarks.Repo do
  use Ecto.Repo,
    otp_app: :bookmarks,
    adapter: Ecto.Adapters.Postgres
end
