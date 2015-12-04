### Asynchronous helpers

One of the nice things about JavaScript is that you can add interactivity to a
web page in a non-blocking manner. For example, you open a modal when a user
clicks a button. Although it takes a couple seconds (you have a sweet
animation), the user's mouse isn't frozen and they still feel in control.

This breaks if we try to test via Capybara:

```ruby
first(".modal-open").click
first(".confirm").click
```

It will click the button but the next interaction will fail because the modal
hasn't finished loading. The ideal behavior would be for the test to wait until
the modal finished loading. We could add a `sleep` here in the test but this
would slow the test down a lot and won't guarantee that the modal is loaded.

Luckily, Capybara provides some helpers for this exact situation. Finders such
as `first` or `all` return `nil` if there is no such element. `find` on the
other hand will keep trying until the element shows up on the page or a maximum
wait time has been exceeded (default 2 seconds). While a `sleep 2` will stop
your tests for two seconds on every run, these finders will only wait as long as
it needs to before moving on.

We can rewrite the previous test as:

```ruby
# this will take a few seconds to open modal
find(".modal-open").click

# this will keep trying to find up to two seconds
find(".confirm").click
```

Similar to `find`, most of Capybara's matchers support waiting. _You should
always use the matchers and not try to call the query methods directly._

```ruby
# This will _not_ retry
expect(page.has_css?(".active")).to eq false

# This _will_ retry if the element isn't initially on the page
expect(page).not_to have_active_class
```
