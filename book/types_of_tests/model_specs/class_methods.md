### Class Methods

Testing class methods works similarly to testing instance methods. I [added some
code] to sort the links from highest to lowest score. To keep our business logic
in our models, I decided to implement a `.hottest_first` method to keep that
logic out of the controller.

[added some code]: https://github.com/thoughtbot/testing-rails/commit/688743177f5ba0c5c0a4a6fdf4446cf8aedcc4a1

We order our model specs as close as possible to how we order our model's
methods. Thus, I added the spec for our new class method under the validations
tests and above the instance method tests.

` spec/models/link_spec.rb@ef04e8996:8,16

This is a fairly common pattern, as many of our ActiveRecord model class methods
are for sorting or filtering. The interesting thing to note here is that I
intentionally scramble the order of the created links. I've also chosen numbers
for the upvotes and downvotes to ensure that the test will fail if we
incidentally are testing something other than what we intend. For example, if we
accidentally implemented our method to sort by upvotes, the test would still
fail.
