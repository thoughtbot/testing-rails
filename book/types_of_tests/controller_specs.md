## Controller Specs

Controller specs exist in a weird space between other test types. They have some
overlap with many of the other test types discussed so far so their use can be
controversial.

In terms of scope they aren't really unit tests because controllers are so
tightly coupled to other parts of the Rails infrastructure. On the other hand,
they aren't integration tests either because requests don't go through the
routes and don't render the view.

As their name implies, controller specs are used to test the logic in a
controller. We've previously seen that feature specs can drive the creation of a
controller. Given that Rails developers actively try to keep logic out of their
controllers and that feature specs do cover controllers, controller tests can
often be redundant. A good rule of thumb is that you don't need a controller
test until you introduce conditional logic to your controller. In our
experience, we tend to write very few controller specs in our applications.

As previously mentioned, feature specs are *slow* (relative to other spec
types). They are best used to test flows through an application. If there are
multiple ways to error out of a flow early, it can be expensive to write the
same feature spec over and over with minor variations.

Time for a controller spec! Or what about a request spec? The two spec types are
quite similar and there are many situations where either would do the job. The
main difference is that controller specs don't actually render views or hit URLs
and go through the routing system.

So if you have logic in a controller and

* the forking logic is part of two distinct and important features, you may want
  a **feature spec**
* you care about the URL, you may want a **request spec**
* you care about the rendered content, you may want a **request spec** or even a
  **view spec**
* none of the above apply, you may want a **controller spec** or a **request
  spec**

One common rule of thumb is to use feature specs for **happy paths** and
controller tests for the **sad paths**.

The "happy path" is where everything succeeds (e.g. successfully navigating the
app and submitting a link) while the "sad path" is where a failure occurs (e.g.
successfully navigating the app but submitting an invalid link). Some flows
through the app have multiple points of potential failure so there can be
multiple "sad paths" for a given "happy path".

All this being said, let's look at an actual controller spec! In this section,
we'll be rewriting the tests for the invalid link case to use a controller spec
rather than a feature spec.

<<[types_of_tests/controller_specs/invalid_links.md]
