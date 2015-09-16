### Dangers

One of the biggest benefits of testing in isolation is just that: the ability to
test-drive the creation of an object without worrying about the implementation
of its collaborators. In fact, you can build an object even if its collaborators
don't even exist yet.

This advantage is also one of its pitfalls. It is possible to have a perfectly
unit-tested system that has components that don't line up with each other or
even have some components missing altogether. The software is broken even though
the test suite is green.

This is why it is important to also have **integration tests** that test that
the system as a whole works as expected. In a Rails application, these will
usually be your feature specs.

RSpec also provides some tools to help us combat this. **Verifying doubles**
(created with the method `instance_double`) take a class as their first
argument. When that class is not loaded, it acts like a regular double. However,
when the class is loaded, it will raise an error if you try to call methods on
the double that are not defined for instances of the class.

` spec/models/score_spec.rb@5b7564bf3b4d25d

Here we convert the score spec to use verifying doubles. Now if we try to make
our doubles respond to methods that `Link` does not respond to (such as
`total_upvotes`), we get the following error:

> Failure/Error: `link = instance_double(Link, total_upvotes: 10, downvotes: 0)`
> Link does not implement: `total_upvotes`

### Brittleness

One of the key ideas behind testing code is that you should test _what_ your
code does, not _how_ it is done. The various techniques for testing in isolation
bend that rule. The tests are more closely coupled to which collaborators an
object uses and the names of the messages the SUT will send to those
collaborators.

This can make the tests more **brittle**, more likely to break if the
implementation changes. For example, if we changed the `LinksController` to use
`save!` instead of `save`, we would now have to update the double or stubbed
method in the tests.
