### AJAX

In addition to just manipulating the UI, it is common to use JavaScript to
communicate asynchronously with the server. Testing this in a feature spec can
be tricky.

Remember, feature specs test the application from a _user's perspective_. As a
user, I don't care whether you use AJAX or not, that is an implementation
detail. What I _do_ care about is the functionality of the application.
Therefore, _feature tests should assert on the UI only_.

So how do you test AJAX via the UI? Imagine we are trying to test an online
document app where you can click a button and your document is saved via AJAX.
How does that interaction look like for the user?

```ruby
click_on "Save"

# This will automatically wait up to 2 seconds
# giving AJAX time to complete
expect(page).to have_css(".notice", text: "Document saved!)
```

Almost all AJAX interactions will change the UI in some manner for usability
reasons. Assert on these changes and take advantage of Capybara's auto-waiting
matchers.
