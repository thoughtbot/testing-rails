## Brittle Tests

When it becomes difficult to make trivial changes to your code without breaking
tests, your test suite can become a burden. Brittle code comes from coupling.
The more coupled your code, the harder it is to make changes without having to
update multiple locations in your code. We want to write test suites that fully
cover all functionality of our application while still being resilient to
change.

We've learned how [stubbing and mocking can lead to brittle
tests](#brittleness).  Here's another example of coupling and some tips to fix
it:

### Coupling to copy and the DOM

An easy way to create brittle tests is to hard code DOM attributes or **[copy]**
(user-facing text) into your tests. These should be easy to change by yourself,
designers, and anyone else on the team without breaking any tests. Most often,
the important thing that you want to test is that a representation of a certain
piece of text or element is appearing in the right spot at the right time. The
actual words and elements themselves are unimportant.

Consider the following:

```html
<div class="welcome-message">
  <p>Welcome, #{current_user.name}</p>
</div>
```


```ruby
expect(page).to have_content "Welcome, #{user.name}"
```

Now, imagine later on that the text in the template needs to change from
`Welcome, #{user.name}` to `Hello again, #{user.name}!`. We'd now have to change
this text in two places, and if we had it in more tests we'd have to change it
in each one. Let's look at some ways to decouple our tests from our copy.

[copy]: https://en.wikipedia.org/wiki/Copy_(written)

#### Internationalization

Our preferred way to decouple your copy from your tests is to use
internationalization (i18n), which is primarily used to support your app in
multiple languages. i18n works by extracting all the copy in your application to
YAML files, which have keys mapping to your copy. In your application, you
reference these keys, which then output the correct text depending on the user's
language.

Using i18n can be costly if you _never_ end up supporting multiple languages,
but if you do end up needing to internationalize your app, it is much easier to
do it from the start. The benefit of doing this up front, is that you don't have
to go back and find and replace every line of copy throughout your app, which
grows in difficulty with the size of your app.

The second benefit of i18n, and why it matters to us here, is that i18n does the
hard work of decoupling our application from specific copy. We can use the keys
in our tests without worrying about the exact text changing out from under us.
With i18n, our tests would look like this:

```html
<div class="welcome-message">
  <p><%= t("dashboards.show.welcome", user: current_user) %></p>
</div>
```


```ruby
expect(page).to have_content t("dashboards.show.welcome", user: user)
```

A change in our copy would go directly into our YAML file, and we wouldn't have
to change a thing in any of our templates or tests.

#### Data Attributes

If you have an existing app that has not been internationalized, an easier way
to decouple your tests from copy or DOM elements is to use data attributes. You
can add data attributes to any HTML tag and then assert on it's presence in your
tests. Here's an example:

```html
<div class="warning" data-role="warning">
  <p>This is a warning</p>
</div>
```


```ruby
expect(page).to have_css "[data-role=warning]"
```

It's important to note that we aren't using `have_css` to assert on the CSS
class or HTML tag either. Classes and tags are DOM elements with high churn and
are often changed by designers who may not be as proficient with Ruby or tests.
By using a separate `data-role`, and teaching designers their purpose, they can
change the markup as much as they want (as long as they keep the `data-role`)
without breaking our tests.

#### Extract objects and methods

As with most things in object-oriented programming, the best way to reduce
duplication and minimize coupling is to extract a method or class that can be
reused. That way, if something changes you only have to change it in a single
place. We'll usually start by extracting common functionality to a method. If
the functionality is more complex we'll then consider extracting a page
object.
