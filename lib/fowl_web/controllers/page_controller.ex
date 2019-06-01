defmodule FowlWeb.PageController do
  use FowlWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
