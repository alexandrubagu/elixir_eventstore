defmodule EventstoreShowcaseWeb.PageController do
  use EventstoreShowcaseWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
