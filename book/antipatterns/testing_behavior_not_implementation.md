## Testing Behavior, Not Implementation

We've said previously that tests should assert on behavior, not implementation.
But, what happens when our tests _do_ know too much about how code is
implemented? Let's look at an example:

```ruby
# app/models/item.rb
class Item < ActiveRecord::Base
  def self.unique_names
    pluck(:name).uniq.sort
  end
end

# spec/models/item_spec.rb
describe Item, ".unique_names" do
  it "returns a list of sorted, unique, Item names" do
    create(:item, name: "Gamma")
    create(:item, name: "Gamma")
    create(:item, name: "Alpha")
    create(:item, name: "Beta")

    expected = Item.pluck(:name).uniq.sort

    expect(Item.unique_names).to eq expected
  end
end
```

The implementation of the method under test is `pluck(:name).uniq.sort`, and
we're testing it against `Item.pluck(:name).uniq.sort`. In essence, we've
repeated the logic, or implementation, of the code directly in our test. There
are a couple issues with this.

For one, if we change how we are getting names in the future — say we change the
underlying field name to `some_name` — we'll have to change the expectation in
our test, even though our expectation hasn't changed. While this isn't the
biggest concern, if our test suite has many instances of this it can become
strenuous to maintain.

Second and more importantly, this test is weak and potentially incorrect. If our
logic is wrong in our production code, it's likely also wrong in our test,
however the test would still be green because our test matches our production
code.

Instead of testing the implementation of the code, we should test it's behavior.
A better test would look like this:

```ruby
describe Item, ".unique_names" do
  it "returns a list of sorted, unique, Item names" do
    create(:item, name: "Gamma")
    create(:item, name: "Gamma")
    create(:item, name: "Alpha")
    create(:item, name: "Beta")

    expect(Item.unique_names).to eq %w(Alpha Beta Gamma)
  end
end
```

Our refactored test specifies the _behavior_ we expect. When the given items
exist, we assert that the method returns `["Alpha", "Beta" "Gamma"]`. We aren't
asserting on logic that could potentially be wrong, but rather how the method
behaves given the above inputs. As an added benefit, it's easier to see what
happens when we call `Item.unique_names`.

Testing implementation details is a common symptom of _not_ following TDD. Once
you know how the code under question will work, it's all too easy to reimplement
that logic in the test. To avoid this in your codebase, be sure you are writing
your tests first.
