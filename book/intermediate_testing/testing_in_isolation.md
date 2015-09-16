## Testing in isolation

In a previous chapter we discussed **unit tests**, tests that exercise a single
component of a system in isolation. That's nice in theory, but in the real world
most objects depend on **collaborators** which may in turn depend on their own
collaborators. You set out to test a single object and end up with a whole
sub-system.

Say we want to add the ability to calculate whether or not a link is
controversial. We're starting to have a lot of score-related functionality so we
extract it into its own `Score` object that takes in a `Link` in its
constructor. `Score` implements the following: `#upvotes`, `#downvotes`,
`#value`, and `#controversial?`.

The spec looks like:

` spec/models/score_spec.rb@e5de94e90a46b9d4

The **system under test** (often abbreviated SUT) is the unit we are trying to
test. In this case, the SUT is the instance of `Score` which we've named `score`
in each test. However, `score` can't do it's work alone. It needs help from a
**collaborator**. Here, the collaborator (`Link`) is passed in as a parameter to
`Score`'s constructor.

You'll notice the tests all follow the same pattern. First, we create an
instance of `Link`. Then we use it to build an instance of `Score`. Finally, we
test behavior on the score. Our test can now *fail for reasons completely
unrelated to the score object*:

* There is no `Link` class defined yet
* `Link`'s constructor expects different arguments
* `Link` does not implement the instance methods `#upvotes` and `#downvotes`

Note that the collaborator doesn't *have* to be an instance of `Link`. Ruby is a
**duck-typed** language which means that collaborators just need to implement an
expected set of methods rather than be of a given class. In the case of the
`Score`'s constructor, any object that implements the `#upvotes`, and
`#downvotes` methods could be a collaborator. For example if we introduce
comments that could be upvoted/downvoted, `Comment` would be another equally
valid collaborator.

Ideally, in a pure unit test we could isolate the SUT from its collaborators so
that only the SUT would cause our spec to fail. In fact, we should be able to
TDD the SUT even if collaborating components haven't been built yet.

<<[intermediate_testing/testing_in_isolation/test_doubles.md]

<<[intermediate_testing/testing_in_isolation/stubbing.md]

<<[intermediate_testing/testing_in_isolation/testing_side_effects.md]

<<[intermediate_testing/testing_in_isolation/terminology.md]

<<[intermediate_testing/testing_in_isolation/benefits.md]

<<[intermediate_testing/testing_in_isolation/dangers.md]

<<[intermediate_testing/testing_in_isolation/a_pragmatic_approach.md]
