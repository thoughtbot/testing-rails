### Stubbing

**Doubles** make it easy for us to isolate collaborators that are passed into
the object we are testing (the **system under test** or **SUT**). Sometimes
however, we have to deal with collaborators that are hard-coded inside our
object. We can isolate these objects too with a technique called **stubbing**.

Stubbing allows us to tell collaborators to return a canned response when they
receive a given message.

` spec/controllers/links_controller_spec.rb@19e77101e30f69dc

In this controller spec, we assert that the form should get re-rendered when
given invalid data. However, validation is not done by the controller (the SUT
in this case) but by a collaborator (`Link`). *This test could pass or fail
unexpectedly if the link validations were updated even though no controller code
has changed.*

We can use a combination RSpec's stubs and test doubles to solve this problem.

` spec/controllers/links_controller_spec.rb@bbac4fd4e5244083

We've already seen how to create a test double to pretend to be a collaborator
that returns the responses we need for a scenario. In the case of this
controller however, the link isn't passed in as a parameter. Instead it is
returned by another collaborator, the hard-coded class `Link`.

RSpec's `allow`, `to_receive`, and `and_return` methods allow us to target a
collaborator, intercept messages sent to it, and return a canned response. In
this case, whenever the controller asks `Link` for a new instance, it will
return our test double instead.

By isolating this controller spec, we can change the definition of what a
"valid" link is all we want without impacting this test. The only way this test
can fail now is if it does not re-render the form when `Link#save` returns
`false`.
