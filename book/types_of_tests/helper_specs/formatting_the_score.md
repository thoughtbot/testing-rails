### Formatting the score

Formatting is not a model-level concern. Instead, we are going to implement it
as a helper method. In TDD fashion we start with a test:

` spec/helpers/application_helper_spec.rb@6335cb210b8e83f5

Since we don't need to persist to the database and don't care about validity, we
are using `Link.new` here instead of `FactoryGirl`.

Helpers are modules. Because of this, we can't instantiate them to test inside a
spec, instead they must be mixed into an object. RSpec helps us out here by
providing the `helper` object that automatically mixes in the described helper.
All of the methods on the helper can be called on `helper`.

It is worth noting here that this is not a pure unit test since it depends on
both the helper *and* the `Link` model. In a later chapter, we will talk about
**doubles** and how they can be used to isolate code from its collaborators.
