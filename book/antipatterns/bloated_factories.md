## Bloated Factories

A factory is the single source of truth for what it takes to instantiate a
minimally valid object. When you define more attributes than you need on a
factory, you implicitly couple yourself to these values every time you use the
factory. These attributes can cause subtle side effects and make your tests
harder to reason about and change as time goes on.

Factories are intended to be customized directly in the test case you are using
them in. This allows you to communicate what is significant about a record
directly in the test. When you set these attributes in the test case itself, it
is easier to understand the causes and effects in the test. This is useful for
both test maintenance and communication about the feature or unit under test.

When defining your factories, define the _minimum number of attributes for the
model to pass validations_. Here's an example:

```ruby
class User < ActiveRecord::Base
  validates :password_digest, presence: true
  validates :username, presence: true, uniqueness: true
end

# DON'T do this

factory :user do
  sequence(:username) { |n| "username#{n}" }
  password_digest "password"
  name "Donald Duck" # according to our model, this attribute is optional
  age 24 # so is this
end

# DO this

factory :user do
  sequence(:username) { |n| "username#{n}" }
  password_digest "password"
end
```
