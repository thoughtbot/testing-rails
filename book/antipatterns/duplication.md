## Duplication

Test code can fall victim to many of the same traps as production code. One of
the worst offenders is duplication. Those who don't recognize this slowly see
productivity drop as it becomes necessary to modify multiple tests with small
changes to the production codebase.

Just like you refactor your production code, you should refactor test code, lest
it become a burden. In fact, refactoring tests should be handled at the same
time as refactoring production code — during the refactoring step in _Red, Green,
Refactor_.

You can use all the tools you use in object oriented programming to DRY up
duplicate test code, such as extracting to methods and classes. For feature
specs, you may consider using [Page Objects](#page-objects) to clean up
repetitive interactions.

You may also consider using i18n to have a single source of truth for all copy.
i18n can help make your tests resilient, as minor copy tweaks won't require any
changes to your test or even production code. This is of course a secondary
benefit to the fact that it allows you to localize your app to multiple
languages!

### Extracting Helper Methods

Common helper methods should be extracted to `spec/support`, where they can be
organized by utility and automatically included into a specific subset of the
tests. Here's an example from [FormKeep's](https://formkeep.com) test suite:

```ruby
# spec/support/kaminari_helper.rb
module KaminariHelper
  def with_kaminari_per_page(value, &block)
    old_value = Kaminari.config.default_per_page
    Kaminari.config.default_per_page = value
    block.call
  ensure
    Kaminari.config.default_per_page = old_value
  end
end

RSpec.configure do |config|
  config.include KaminariHelper, type: :request
end
```

The above code allows us to configure Kaminari's `default_per_page` setting in
the block, and ensures it is set back to the original value. The
`RSpec.configure` bit includes our module into all request specs. This file (and
others in `spec/support`) is automatically included in our `rails_helper.rb`:

` spec/rails_helper.rb@0eb55ce8d6ea88:22
