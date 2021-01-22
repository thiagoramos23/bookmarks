defmodule Bookmarks.Bookmark.IconModifier do

  def modify(bookmark) do
    with {:ok, body} <- body_parsed_from(bookmark.url),
         {:ok, html} <- html_from_parsed_body(body),
         {:ok, url}  <- get_first_image_url_from_html(html)
    do

    else
      {:error, error_message} -> "Error when modifying icon: #{error_message}"
    end
  end

  defp body_parsed_from(url) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get(url)
    {:ok, body}
  end

  defp html_from_parsed_body(body) do
    {:ok, html} = Floki.parse_document(body)
    {:ok, html}
  end

  defp get_first_image_url_from_html(html) do
    url = Floki.find(html, "img") 
      |> List.first 
      |> elem(1) 
      |> Enum.into(%{}) 
      |> Map.get("src")
    {:ok, url}
  end
end
