## Using Factories Like Fixtures

While [we prefer factories over fixtures](#factorygirl), it is important to use factories
appropriately. Occasionally, we'll see test suites that use `FactoryGirl` as if
they were fixtures which is the worst of both worlds. Factories are great
because they are flexible, however they can be slower than fixtures. When you
use them like fixtures, they can be slow and inflexible.

There are two ways we've seen people use factories like fixtures:

### Defining more attributes than you need

When you define your factories, you declare all of the attributes the factory
should be initialized with. When you define more attributes than you need on a
factory, these attributes are set by default in every test, and can subtly cause
side effects. This become harder to reason about as your test suite grows,
especially if many of your tests end up depending on this default behavior.

Factories are intended to be customized directly in the test case you are using
them in. If your test case depends on a model with a specific attribute, that
attribute should be set on the model when it is initialized in the test case,
not in some other file. When you set these attributes in the test case itself,
it is far easier to understand the causes and effects of what happens in your
test. It also makes it easier to see what conditions are important for the test
to pass.

When defining your factories, define the _minimum number of attributes for the
model to pass validations_. Here's an example:

```
class User < ActiveRecord::Base
  validates :password_digest, presence: true
  validates :username, presence: true, uniqueness: true
end

# DON'T do this

factory :user do
  sequence(:username) { |n| "username#{n}" }
  password_digest "password
  name "Donald Duck"
  age 24
end

# DO this

factory :user do
  sequence(:username) { |n| "username#{n}" }
  password_digest "password
end
```

### Defining multiple factories for a single model

The second way people use factories like fixtures is less common but more
reminiscent of fixtures. Essentially, we've seen people write multiple
factories for a single model, each defining attributes that are specific to the
factories use case. This brings us back to the fixture problem where important
attributes for our test cases are defined outside the scope of our tests.

When you need to group differentiate models with specific functionalities, use
traits to define the _necessary_ attributes. That way, you can define one or
more traits directly in the test, and only bring in the traits you need. Again,
by defining only the attributes that are necessary, we can avoid coupling to
default attributes in our tests.

```
class User < ActiveRecord::Base
  validates :password_digest, presence: true
  validates :username, presence: true, uniqueness: true
end

# DON'T do this

factory :admin_user, class: User do
  sequence(:username) { |n| "admin_username#{n}" }
  password_digest "password
  name "Mr. Admin"
  age 27
  admin true
end

factory :normal_user, class: User do
  sequence(:username) { |n| "username#{n}" }
  password_digest "password
  name "Donald Duck"
  age 24
  admin false
end

# DO this

factory :user do
  sequence(:username) { |n| "username#{n}" }
  password_digest "password

  trait :admin do
    admin true
  end
end
```
