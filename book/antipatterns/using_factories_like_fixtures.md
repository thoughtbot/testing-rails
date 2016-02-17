## Using Factories Like Fixtures

While [we prefer factories over fixtures](#factorygirl), it is important to use
factories appropriately to get any benefit. Occasionally we'll see test suites
create factory definitions as if they were fixtures:

```ruby
factory :pam, class: User do
  name "Pam"
  manager false
end

factory :michael, class: User do
  name "Michael"
  manager true
end
```

This is the worst of both worlds. Factories are great because they're flexible,
however they are slower than fixtures. When you use them like fixtures, they are
slow, inflexible, _and_ cryptic. As the factory definitions grow, they tend to
violate the rule of having a minimal set of attributes for a valid records. In
addition to the [issues that brings](#bloated-factories), it becomes difficult
to remember which factories return which attributes.

Instead of creating multiple factory definitions to group related functionality,
use traits or nested factories.

Traits allow you to compose attributes within the test itself.

```ruby
factory :message do
  body "What's up?"

  trait :read do
    read_at { 1.month.ago }
  end
end

# In the test
build_stubbed(:message, :read) # it's clear what we're getting here
```

You may even consider pulling traits out to the global level for reuse between
factories:

```ruby
factory :message do
  # noop
end

factory :notification do
  # noop
end

trait :read do
  read_at { 1.month.ago }
end

# In the test
build_stubbed(:message, :read)
build_stubbed(:notification, :read)
```

In addition to traits, you can extend functionality through inheritance with
nested factories:

```ruby
factory :user do
  sequence(:username) { |n| "username#{n}" }
  password_digest "password"

  factory :subscriber do
    subscribed true
  end
end

# In the test
build_stubbed(:subscriber)
```

This allows you to better communicate state and still maintain a single source
of knowledge about the necessary attributes to build a user.

```ruby
# This is good
build_stubbed(:user, :subscribed)

# This is better
build_stubbed(:subscriber)
```

Note that nesting is not as composable as traits since you can only build an
object from a single factory. Traits, however, are more flexible as multiple can
be used at the same time.
