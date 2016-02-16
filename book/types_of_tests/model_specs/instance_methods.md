### Instance Methods

In the last chapter, we added functionality for users to vote on links with some
instance methods on our `Link` class to help with this.

#### Link#upvote

The first method is `#upvote`, which increments the `upvotes` count on the
link by 1. A simple way to test this behavior is to instantiate an object with a
known upvote count, call our `#upvote` method, and then verify that the new
upvote count is what we expect. A test for that might look like this:

` spec/models/link_spec.rb@d4001c148:8,16

`.describe` comes from RSpec and creates a group for whatever functionality you
are describing. It takes a subject, in our case the `Link` class, and the
behavior as a string. Typically, we'll use the name of our method, in this case
`#upvote`. We prefix instance methods with a `#` and class methods with a `.`.

```
link = build(:link, upvotes: 1)
```

`.build` is another FactoryGirl method. It's similar to `.create`, in that it
instantiates an object based on our factory definition, however `.build` does
not save the object. Whenever possible, we're going to favor `.build` over
`.create`, as persisting to the database is one of the slowest operations in our
tests. In this case, we don't care that the record was saved before we increment
it so we use `.build`. If we needed a persisted object (for example, if we
needed to query for it), we would use `.create`.

You might ask, "Why not use `Link.new`?". Even though we don't save our record
immediately, our call to `link.upvote` will, so we need a valid `Link`. Rather
than worrying about what attributes need to be set to instantiate a valid
instance, we depend on our factory definition as the single source of truth on
how to build a valid record.

Our _verify_ step is slightly different than we've seen in our feature specs.
This time, we aren't asserting against the `page` (we don't even have access to
the page, since this isn't a Capybara test). Instead, we're asserting against
our system under test: the link. We're using a built in RSpec matcher `eq` to
confirm that the *expected* value, `2`, matches the *actual* value of
`link.upvotes`.

With the test written, we can implement the method as such:

` app/models/link.rb@d4001c148:5,7

#### Link#score

Our score method should return the difference of the number of upvotes and
downvotes. To test this, we can instantiate a link with a known upvote count and
downvote count, then compare the expected and actual scores.

` spec/models/link_spec.rb@d4001c148:28,34

In this test, you'll notice that we forgo FactoryGirl and use plain ol'
ActiveRecord to instantiate our object. `#score` depends on `#upvotes` and
`#downvotes`, which we can set without saving our object. Since we never have to
save our object, we don't need FactoryGirl to set up a valid record.

With a failing test, we can write our implementation:

` app/models/link.rb@d4001c148:13,15
