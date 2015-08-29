### Submitting an invalid link

All links should have a title and URL, so we should prevent users from
submitting invalid links. Since this is part of the "User submits a link"
feature, we can add it to the same feature block under a different scenario. A
basic feature spec might look like this:

` spec/features/user_submits_a_link_spec.rb@5ed398161:17,28

This test intentionally leaves the URL blank, and expects to see an error
message on the page for the missing URL. While we could test every possible path
(without a title, without a URL, without both), we really only need to test one
at an integration level. This will assure us that an error message renders if the
link is invalid. To ensure that each of our fields are valid, we instead test
this at the model layer. You can see how I tested this in the [respective
commit], but we won't cover model specs until the next chapter.

[respective commit]: https://github.com/thoughtbot/testing-rails/commit/5ed3981619066bb71c1b8f4b17647c57aebd2707

There are a couple new methods in this test. The first is `#context`. As you
might guess, it allows you to provide additional context to wrap one or more
scenarios. In fact, you can even nest additional context blocks, however we
recommend against that. Specs are much easier to read with minimal nesting. If
you need to nest scenarios more than a couple levels deep, you might consider
pulling out a new feature file.

The other new method is `#have_content`. Like `#have_link`, this method comes
from Capybara, and is actually `#has_content?`. `#has_content?` will look on the
page for the given text, ignoring any HTML tags.

#### Passing the test

As always, I'll run the test now and follow the error messages to a solution.
I'll leave this up to the reader, but feel free to check out [the commit] to see
what I did.

[the commit]: https://github.com/thoughtbot/testing-rails/commit/5ed3981619066bb71c1b8f4b17647c57aebd2707

#### Four Phase Test

You'll note that in each of our tests so far, we've used some strategic spacing.
This spacing is meant to make the tests easier to read by sectioning it into
multiple phases. The pattern here is modeled after the [Four Phase Test], which
takes the form:

[Four Phase Test]: http://xunitpatterns.com/Four%20Phase%20Test.html

```
test do
  setup
  exercise
  verify
  teardown
end
```

**Setup**

During setup, we create any objects that your test depends on.

**Exercise**

During exercise, we execute the functionality we are testing.

**Verify**

During verify, we check our expectations against the result of the exercise
phase.

**Teardown**

During teardown, we clean-up after ourselves. This may involve resetting the
database to it's pre-test state or resetting any modified global state. This is
usually handled by our test framework.

Four phase testing is more prominently used with model and unit tests, however
it is still useful for our acceptance tests. This is especially true for simple
tests like the two we've demonstrated, however some acceptance tests may be
large enough to warrant even more grouping. It's best to use your discretion and
group things into logical sections to make code easier to read.
