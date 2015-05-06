### Validations

We use a library called [shoulda-matchers] to test validations.
`shoulda-matchers` provides matchers for writing single line tests for common
Rails functionality. Testing validations in your model is important, as it is
unlikely validations will be tested anywhere else in your test suite.

[shoulda-matchers]: https://github.com/thoughtbot/shoulda-matchers

To use `shoulda-matchers`, add the gem to your Gemfile's `:test` group:

```ruby
gem "shoulda-matchers"
```

After bundle installing, you can use the built in matchers ([see more
online][shoulda-matchers]) like so:

```ruby
RSpec.describe Link, "validations" do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:url) }
  it { is_expected.to validate_uniqueness_of(:url) }
end
```

`is_expected` is an RSpec method that makes it easier to write one line tests.
The `it` these tests refer to is the test's `subject`, a method provided by
RSpec when you pass a class as the first argument to `describe`. RSpec takes the
subject you pass into `describe`, and instantiates a new object. In this case,
`subject` returns `Link.new`. `is_expected` is a convenience syntax for
`expect(subject)`. It reads a bit nicer when you read the whole line with the
`it`. The following lines are roughly equivalent:

```ruby
RSpec.describe Link, "validations" do
  it { expect(Link.new).to validate_presence_of(:title) }
  it { expect(subject).to validate_presence_of(:url) }
  it { is_expected.to validate_uniqueness_of(:url) }
end
```

### Associations

While `shoulda-matchers` provides methods for testing associations, we've found
that adding additional tests for associations is rarely worth it, as
associations will be tested at an integration level. Since we haven't found them
useful for catching regressions or for helping us drive our code, we have
stopped using them.
