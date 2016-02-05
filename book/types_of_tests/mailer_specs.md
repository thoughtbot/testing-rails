## Mailer Specs

As with every other part of your Rails application, mailers should be tested at
an integration and unit level to ensure they work and will continue to work as
expected.

Say we send an email to moderators when a new link is added to the site.
Following an outside-in development process, we'll start with an integration
level test. In this case, a controller spec:

` spec/controllers/links_controller_spec.rb@db8110e40a4cc40a:15,25

This test introduces some new methods. We'll discuss the intricacies of how this
works in [testing side effects](#testing-side-effects). For now, just realize
that we've set up an expectation to check that when a link is created, we call
the method `LinkMailer#new_link`. With this in place, we can be comfortable that
when we enter the conditional in our controller, that method is called. We'll
test what that method does in our unit test.

The above spec would lead to a controller action like this:

` app/controllers/links_controller.rb@b6755ba1b764d1d1:14,23

This now forces us to write a new class and method `LinkMailer#new_link`.

#### LinkMailer#new_link

Before writing our test we'll install the [`email-spec`] gem, which provides a
number of helpful matchers for testing mailers, such as:

* `deliver_to`
* `deliver_from`
* `have_subject`
* `have_body_text`

[`email-spec`]: https://github.com/email-spec/email-spec

With the gem installed and setup, we can write our test:

` spec/mailers/link_mailer_spec.rb@4c52a0167e5b5240

This test confirms our `to`, `from`, `subject` and `body` are what we expect.
That should give us enough coverage to be confident in this mailer, and allow us
to write our mailer code:

` app/mailers/link_mailer.rb@4c52a0167e5b5240
