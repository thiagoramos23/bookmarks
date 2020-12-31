defmodule BookmarksWeb.BookmarksLive do
  use BookmarksWeb, :live_view

  alias Bookmarks.Bookmark
  alias Bookmarks.Bookmark.Website
  alias Bookmarks.Accounts

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      user = get_user(session, socket)
      websites = Bookmark.list_websites(%{user: user})
      {:ok, assign(socket, bookmark: %Website{}, user_id: user.id, websites: websites, query: "")}
    else
      {:ok, assign(socket, bookmark: %Website{}, websites: [], query: "")}
    end
  end

  ## Events

  @impl true
  def handle_event("save_bookmark", %{"id" => id, "name" => name, "url" => url, "tags" => tags}, socket) do
    user    = Accounts.get_user!(socket.assigns.user_id)
    website = Bookmark.get_website!(id)
    attrs = %{name: name, url: url, tags: tags}
    case Bookmark.update_website(website, attrs) do
      {:ok, _} ->
        websites = Bookmark.list_websites(%{user: user})
        {:noreply,
          socket
          |> assign(:websites, websites)
          |> assign(:bookmark, %Website{})
          |> put_flash(:info, "Bookmark updated!")
        }
      {:error, _} ->
        {:noreply,
          socket
          |> put_flash(:error, "We had a problem updating the bookmark")
        }
    end
  end

  @impl true
  def handle_event("save_bookmark", %{"name" => name, "url" => url, "tags" => tags}, socket) do
    user  = Accounts.get_user!(socket.assigns.user_id)
    attrs = %{name: name, url: url, tags: tags, user: user}
    case Bookmark.create_website(attrs) do
      {:ok, _} ->
        websites = Bookmark.list_websites(%{user: user})
        {:noreply,
          socket
          |> assign(:websites, websites)
          |> put_flash(:info, "Bookmark added!")
        }
      {:error, _} ->
        {:noreply,
          socket
          |> put_flash(:error, "We had a problem adding the bookmark")
        }
    end
  end



  @impl true
  def handle_event("change_bookmark", %{"value" => id}, socket) do
    bookmark = Bookmark.get_website!(id)
    {:noreply,
      socket
      |> assign(:bookmark, bookmark)
    }
  end


  @impl true
  def handle_event("delete_bookmark", %{"value" => id}, socket) do
    website = Bookmark.get_website!(id)
    case Bookmark.delete_website(website) do
      {:ok, _} ->
        user  = Accounts.get_user!(socket.assigns.user_id)
        websites = Bookmark.list_websites(%{user: user})
        {:noreply,
          socket
          |> assign(:websites, websites)
          |> put_flash(:info, "Bookmark added!")
        }
      {:error, _} ->
        {:noreply,
          socket
          |> put_flash(:error, "We had a problem deleting this bookmark")
        }
    end
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    websites = search(query, socket.assigns.user_id)
    {:noreply, assign(socket, websites: websites)}
  end

  ## Private Methods

  defp search(query, user_id) do
    Bookmark.list_websites_by(%{user_id: user_id, param: query})
  end

  defp get_user(session, socket) do
    if user_id = Map.get(socket, :user_id) do
      Accounts.get_user!(user_id)
    else
      socket_id = Map.get(session, "live_socket_id")
      token = socket_id |> String.split(":") |> List.last |> Base.decode64!
      user = Accounts.get_user_by_session_token(token)
      user
    end
  end
end
