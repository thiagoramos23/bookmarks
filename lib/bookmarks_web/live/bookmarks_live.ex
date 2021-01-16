defmodule BookmarksWeb.BookmarksLive do
  use BookmarksWeb, :live_view

  alias Bookmarks.Bookmark
  alias Bookmarks.Bookmark.Website
  alias Bookmarks.Accounts
  alias Bookmarks.Accounts.User
  alias BookmarksWeb.ModalComponent
  alias BookmarksWeb.BookmarkFormComponent

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
      user = get_user(session, socket)
      websites = Bookmark.list_websites(%{user: user})

      {:ok,
       assign(socket,
         changeset: Bookmark.change_website(%Website{}),
         user_id: user.id,
         websites: websites,
         bookmark_to_delete: nil,
         query: ""
       )}
    else
      {:ok,
       assign(socket, changeset: Bookmark.change_website(%Website{}), user_id: nil, websites: [], query: "")}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("edit_bookmark", %{"bookmark-id" => bookmark_id}, socket) do
    {:noreply, push_patch_to_with_id(socket, :edit_bookmark, String.to_integer(bookmark_id))}
  end

  @impl true
  def handle_event("delete_bookmark", %{"bookmark-id" => bookmark_id}, socket) do
    {:noreply, push_patch_to_with_id(socket, :delete_bookmark, String.to_integer(bookmark_id))}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    websites = search(query, socket.assigns.user_id)
    {:noreply, assign(socket, websites: websites)}
  end

  ## BookmarkFormComponent Handle Events
  @impl true
  def handle_info({BookmarkFormComponent, :bookmark_saved, success_message, user}, socket) do
    {:noreply,
      push_patch(
        socket
        |> assign(:changeset, Bookmark.change_website(%Website{}))
        |> assign(:websites, Bookmark.list_websites(%{user: user}))
        |> put_flash(:info, success_message),
        to: Routes.bookmarks_path(socket, :index),
        replace: true
      )
    }
  end

  ## Modal Component Handle Events
  # Handle message to self() from Remove Bookmark confirmation modal ok button
  @impl true
  def handle_info(
        {ModalComponent, :button_pressed, %{action: "delete-bookmark"}},
        %{assigns: %{bookmark_to_delete: bookmark_to_delete}} = socket
      ) do
    {:ok, websites} = delete_bookmark(bookmark_to_delete, socket)

    {:noreply,
     socket
     |> assign(:websites, websites)
     |> put_flash(:info, "Bookmark deleted successfuly")}
  end

  # Handle message to self() from Remove User confirmation modal cancel button
  @impl true
  def handle_info(
        {ModalComponent, :button_pressed, %{action: "cancel-delete-bookmark", param: _}},
        socket
      ) do
    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {ModalComponent, :modal_closed, %{id: "confirm-delete-bookmark"}},
        socket
      ) do
    {:noreply, push_patch_to(socket, :index)}
  end

  ## Private Methods

  defp delete_bookmark(bookmark, socket) do
    case Bookmark.delete_website(bookmark) do
      {:ok, _} ->
        user = Accounts.get_user!(socket.assigns.user_id)
        websites = Bookmark.list_websites(%{user: user})
        {:ok, websites}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp apply_action(socket, :edit_bookmark, %{"id" => bookmark_id}) do
    website = Bookmark.get_website!(bookmark_id)
    assign(socket, changeset: Bookmark.change_website(website))
  end

  defp apply_action(socket, :delete_bookmark, %{"id" => bookmark_id}) do
    website = Bookmark.get_website!(bookmark_id)

    if website do
      assign(socket, bookmark_to_delete: website)
    else
      push_patch_to(socket, :index)
    end
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, bookmark_to_delete: nil)
  end

  defp push_patch_to_with_id(socket, action, bookmark_id) do
    push_patch(
      socket,
      to: Routes.bookmarks_path(socket, action, bookmark_id),
      replace: true
    )
  end

  defp push_patch_to(socket, action) do
    push_patch(
      socket,
      to: Routes.bookmarks_path(socket, action),
      replace: true
    )
  end

  defp search(query, user_id) do
    Bookmark.list_websites_by(%{user_id: user_id, param: query})
  end

  defp get_user(session, socket) do
    if user_id = Map.get(socket, :user_id) do
      Accounts.get_user!(user_id)
    else
      socket_id = Map.get(session, "live_socket_id")
      token = socket_id |> String.split(":") |> List.last() |> Base.url_decode64!()
      Accounts.get_user_by_session_token(token)
    end
  end
end
