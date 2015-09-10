### Test doubles

RSpec gives us **test doubles** (sometimes also called **mock objects**) which
act as fake collaborators in tests. The name derives from stunt doubles in
movies that stand in for the real actor when a difficult stunt needs to be done.
Test doubles are constructed with the `double` method. It takes an optional hash
of methods it needs to respond to as well as their return values.

Let's try using this in our spec:

` spec/models/score_spec.rb@10efa8bc7779a520

Here, we've replaced the dependency on `Link` and are constructing a double that
responds to the following interface:

* `upvotes`
* `downvotes`

### Historical note

Older versions of RSpec had methods named `stub` and `mock` as aliases to
`double`. This is particularly confusing because **mocking** and **stubbing**
are entirely different concepts (more on them later). To make things worse,
RSpec also monkeypatched `Object` with an `Object.stub` method which *did* do
real stubbing. You shouldn't run into these unless you are working with a legacy
test suite.
