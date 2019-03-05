defmodule EventstoreShowcase.UsersTest do
  use EventstoreShowcase.DataCase

  alias EventstoreShowcase.Users

  test "create_user" do
    params = %{"name" => "alexandrubagu"}
    assert {:ok, user} = Users.create_user(params)
    assert user.name == "alexandrubagu"
  end
end
