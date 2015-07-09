### Benefits

Taking this approach yields several benefits. Because we aren't using real
collaborators, we can TDD a unit of code even if the collaborators haven't been
written yet.

Using test doubles gets painful for components that are highly coupled to many
collaborators. Let that pain drive you to reduce the coupling in your system.
Remember the final step of the TDD cycle is *refactor*.

Test doubles make the interfaces the SUT depends on explicit. Whereas the old
spec said that the helper method relied on a `Link`, the new spec says that
methods on `Score` depend on an object that must implement `#upvotes`, and
`#downvotes`. This improves the unit tests as a source of documentation.
