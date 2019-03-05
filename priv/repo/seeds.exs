r = Enum.random(1..999_999_999)
name = "alexandrubagu#{r}"
EventstoreShowcase.Users.create_user(%{"name" => name})
user = EventstoreShowcase.Repo.get_by(EventstoreShowcase.User, name: name)

EventstoreShowcase.Users.modify_user(user, %{"name" => "test"})
