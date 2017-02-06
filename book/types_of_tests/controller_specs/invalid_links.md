### Invalid Links

In this test, we want to try and submit an invalid link and expect that it will
not succeed but that the form will be re-rendered.

The specs looks like this:

` spec/controllers/links_controller_spec.rb@19e77101e30f69dc

Just like with the request spec, the `post` method will make a `POST` request.
However, unlike the request spec, we are making the request directly to a
controller action rather than to a URL.

The first parameter to `post` is the action we want to exercise. In addition, we
may pass an optional hash of params. Since we are simulating a form submission,
we need a hash of attributes nested under the `link` key. We can generate these
attributes by taking advantage of the invalid link factory we created
earlier. Finally, the controller is inferred from the `RSpec.describe`.

This will make a `POST` request to the `LinksController#create` action with an
invalid link as its payload.

Controller specs expose a `response` object that we can assert against. Although
we cannot assert against actual rendered content, we can assert against the name
of the template that will be rendered.

It is worth noting here that this spec is *not* equivalent to the feature spec
it replaces. The feature test tested that an error message *actually appeared on
the page*. The controller test, on the other hand, only tests that the form gets
re-rendered.

This is one of those situations where you have to make a judgment call. Is it
important enough to test that the error message shows up on the page, or is
testing that the application handles the error sufficient? Is it worth trading a
slow and partially duplicated feature spec for a faster controller test that
doesn't test the UI? Would a request spec be a good compromise? What about a
controller spec plus a view spec to test the both sides independently?

All of these options are valid solutions. Based on the context you will pick the
one that gives you the best combination of confidence, coverage, and speed.
