defmodule BookmarksWeb.BookmarkFormComponent do
  use BookmarksWeb, :live_component

  alias Bookmarks.Bookmark
  alias Bookmarks.Bookmark.Website
  alias Bookmarks.Accounts

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  ## Events
  def handle_event(
        "save_bookmark",
        %{"website" => %{"id" => id, "name" => name, "url" => url, "tags" => tags}},
        socket
      ) do
    user = Accounts.get_user!(socket.assigns.user_id)
    website = Bookmark.get_website!(id)
    attrs = %{name: name, url: url, tags: tags, user: user}

    case Bookmark.update_website(website, attrs) do
      {:ok, _} ->

        send(self(), {__MODULE__, :bookmark_saved, "Bookmark Updated", user})
        {:noreply, socket}

      {:error, changeset} ->

        {:noreply, socket, assign(socket, changeset: changeset)}
    end
  end

  def handle_event(
        "save_bookmark",
        %{"website" => %{"name" => name, "url" => url, "tags" => tags}},
        socket
      ) do
    user = Accounts.get_user!(socket.assigns.user_id)
    attrs = %{name: name, url: url, tags: tags, user: user}

    case Bookmark.create_website(attrs) do
      {:ok, _} ->

        send(self(), {__MODULE__, :bookmark_saved, "Bookmark Saved", user})
        # {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("https://elixir-lang.org")
        #  {:ok, html} = Floki.parse_document(body)
        #Floki.find(html, "img") |> List.first |> elem(1) |> Enum.into(%{}) |> Map.get("src")
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->

        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_event("validate", %{"website" => params}, socket) do
    changeset =
      case params do
        %{"id" => id} ->
          Bookmark.get_website!(id)
          |> Bookmark.change_website(params)
          |> Map.put(:action, :update)

        _ ->
          %Website{}
          |> Bookmark.change_website(params)
          |> Map.put(:action, :insert)
      end

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div id="stateful-<%= @id %>">
      <%= f = form_for @changeset, "#", [phx_change: :validate, phx_submit: :save_bookmark, "phx-target": "#stateful-#{@id}"] %>
        <%= if @changeset.data.id do %>
          <%= hidden_input f, :id %>
        <% end %>
        <div class="flex flex-col items-start">
          <p class="py-8 font-sans text-4xl antialiased font-semibold text-gray-600">Add a new bookmark</p>
          <div class="flex flex-col items-center w-full bg-gray-100 shadow md:items-start rounded-2xl">
            <div class="flex flex-col w-full md:flex-row">
              <div class="flex flex-col items-start w-full p-6 md:w-1/3">
                <label class="text-3xl antialiased font-medium text-gray-700">Name</label>
                <%= text_input f, :name,
                    class: "w-full h-20 px-5 pr-10 text-2xl antialiased text-center placeholder-gray-600 bg-white shadow md:text-3xl rounded-2xl focus:outline-none",
                    placeholder: "Add the name of you new bookmark" %>
                <%= error_tag f, :name %>
              </div>
              <div class="flex flex-col items-start w-full p-6 md:w-1/2">
                <label class="text-3xl antialiased font-medium text-gray-700">URL</label>
                <%= text_input f, :url,
                    class: "w-full h-20 px-5 pr-10 text-2xl antialiased text-center placeholder-gray-600 bg-white shadow md:text-3xl rounded-2xl focus:outline-none",
                    placeholder: "Add the URL of you new bookmark" %>
                <%= error_tag f, :url %>
              </div>
              <div class="flex flex-col items-start w-full p-6 md:w-1/3">
                <label class="text-3xl antialiased font-medium text-gray-700">Tags</label>
                <%= text_input f, :tags,
                    class: "w-full h-20 px-5 pr-10 text-2xl antialiased text-center placeholder-gray-600 bg-white shadow md:text-3xl rounded-2xl focus:outline-none",
                    placeholder: "Tags should be separated by comma" %>
                <%= error_tag f, :tags %>
              </div>
            </div>
            <div class="flex w-full px-6 md:items-start">
              <%= submit "Save Bookmark", class: "w-full mb-10 font-sans font-normal text-gray-100 bg-gray-700 outline-none md:w-1/5 md:px-4 md:py-2 rounded-xl" %>
            </div>
          </div>
        </div>
      </form>
    </div>
    """
  end
end
