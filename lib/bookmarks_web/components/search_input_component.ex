defmodule BookmarksWeb.SearchInputComponent do
  use BookmarksWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    send(
      self(), 
      {__MODULE__, :execute_search, %{term: query, user_id: socket.assigns.user_id}}
    )

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div id="stateful-search-search_input_component">
      <form class="col-span-1 sm:col-span-3" phx-change="search" phx-target="#stateful-search-search_input_component">
        <div class="relative">
          <input
            phx-debounce="400"
            name="q" value="<%= @query %>"
            class="w-full h-20 px-5 pr-10 text-2xl antialiased text-center placeholder-gray-600 bg-white shadow md:text-3xl rounded-2xl focus:outline-none"
            placeholder="Search for urls or tags or names">
          <svg class="absolute top-0 left-0 w-8 h-8 mt-6 ml-4 text-gray-600 fill-current" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Capa_1" x="0px" y="0px" viewBox="0 0 56.966 56.966" style="enable-background:new 0 0 56.966 56.966;" xml:space="preserve" width="512px" height="512px">
            <path d="M55.146,51.887L41.588,37.786c3.486-4.144,5.396-9.358,5.396-14.786c0-12.682-10.318-23-23-23s-23,10.318-23,23  s10.318,23,23,23c4.761,0,9.298-1.436,13.177-4.162l13.661,14.208c0.571,0.593,1.339,0.92,2.162,0.92  c0.779,0,1.518-0.297,2.079-0.837C56.255,54.982,56.293,53.08,55.146,51.887z M23.984,6c9.374,0,17,7.626,17,17s-7.626,17-17,17  s-17-7.626-17-17S14.61,6,23.984,6z"/>
          </svg>
        </div>
      </form>
    </div>
    """
  end
end
