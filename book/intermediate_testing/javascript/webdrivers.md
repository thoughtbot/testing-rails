### Webdrivers

At the integration level, we don't care what technology is being used under the
hood. The focus is on the user interactions instead. By default, RSpec/Capybara
run feature specs using `Rack::Test` which simulates a browser. Although it is
fast, it cannot execute JavaScript.

In order to execute JavaScript, we need a real browser. Capybara allows using
different **drivers** instead of the default of `Rack::Test`.
[Selenium][selenium] is a wrapper around Firefox that gives us programmatic
access. If you configure Capybara to use Selenium, you will see a real Firefox
window open up and run through your scenarios.

The downside to Selenium is that it is slow and somewhat brittle (depends on
your version of Firefox installed). To address these issues, it is more common
to use a **headless driver** such as [Capybara Webkit][webkit] or
[Poltergeist][poltergeist]. These are real browser engines but without the UI.
By packaging the engine and not rendering the UI, these headless browsers can
improve speed by a significant factor as well as avoid breaking every time you
upgrade your browser.

[selenium]: https://github.com/seleniumhq/selenium
[webkit]: https://github.com/thoughtbot/capybara-webkit
[poltergeist]: https://github.com/teampoltergeist/poltergeist

To use a JavaScript driver (Capybara Webkit in this case) you install its gem
and then point Capybara to the driver. In your `rails_helper.rb`, you want to
add the following:

```ruby
Capybara.javascript_driver = :webkit
```

Then, you want to add a `:js` tag to all scenarios that need to be run with
JavaScript.

```ruby
feature "A user does something" do
  scenario "and sees a success message", :js do
    # test some things
  end
end
```
