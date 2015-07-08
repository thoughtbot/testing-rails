## The Testing Pyramid

The various test types we are about to look at fall along a spectrum. At one end
are **unit tests**. These test individual components in isolation, proving that
they implement the expected behavior independent of the surrounding system.
Because of this, unit tests are usually small and fast.

In the real world, these components don't exist in a vacuum: they have to
interact with each other. One component may expect a collaborator to have a
particular interface when in fact it has completely different one. Even though
all the tests pass, the software as a whole is broken.

This is where **integration tests** come in. These tests exercise the system as
a whole rather than its individual components. They typically do so by
simulating a user trying to accomplish a task in our software. Instead of being
concerned with invoking methods or calling out to collaborators, integration
tests are all about clicking and typing as a user.

Although this is quite effective for proving that we have working software, it
comes at a cost. Integration tests tend to be much slower and more brittle than
their unit counterparts.

Many test types are neither purely unit nor integration tests. Instead, they lie
somewhere in between, testing several components together but not the full
system.

![Rails Test Types](../images/rails-test-types.png)

We like to build our test suite using a combination of these to create a
[**testing pyramid**](http://martinfowler.com/bliki/TestPyramid.html). This is a
suite that has a few high-level integration tests that cover the general
functionality of the app, several intermediate-level tests that cover a
sub-system in more detail, and many unit tests to cover the nitty-gritty details
of each component.

This approach plays to the strength of each type of test while attempting to
minimize the downsides they have (such as slow run times).
