### Viewing the homepage

Now that we can create links, we should test that we actually see them on the
homepage. Again, we'll start with some pseudocode:

```
As a user
Given a link has already been submitted
When I visit the home page
Then I should see the link's title on the page
And it should link to the correct URL
```

This test is a little different than our last. This time we have a "given".
Instead of creating a link ourselves, we're going to assume one already exists.
The reason behind this is simple. Walking through our application with Capybara
is slow. We shouldn't do it any more than we have to. We've already tested that
we can submit a link, so we don't need to test it again. Instead, we can create
records directly in the database.

We could go about creating records the way you'd expect:

```ruby
link = Link.create(title: "Testing Rails", url: "http://testingrailsbook.com")
```

This _would_ work, but it has some serious downfalls when using it to test
software. Imagine we have a large application, with hundreds of tests, each one
having created a `Link` the manual way. If we were to add a required field to
links, we would have to go through all of our tests and add the required field
for _all_ of these tests to get them to pass again. There are two widely used
fixes for this pain point. The first one is called fixtures.

#### Fixtures

Fixtures allow you to define sample data in YAML files that you can
load and reuse through your tests. It might look something like this:


```yaml
# fixtures/links.yml
testing_rails:
  title: Testing Rails
  url: http://testingrailsbook.com
```

```ruby
# In your test
link = links(:testing_rails)
```

Now that we've extracted the definition of our _Testing Rails_ link, if our
model adds new required fields we only have to update our fixtures file. This is
a big step up, but we still see some problems with this solution.

For one, fixtures are a form of **Mystery Guest**. You have a Mystery Guest when
data used by your test is defined outside the test, thus obscuring the cause and
effect between that data and what is being verified. This makes tests harder to
reason about, because you have to hunt down another file to be able to
understand the entirety of what is happening.

As applications grow, you'll typically need variations on each of your models
for different situations. For example, you may have a fixture for every user
role in your application, then even more users for different roles depending on
whether or not the user is a member of a specific organization. All these are
possible states a user can be in and grow the number of fixtures you will have to
recall.

#### FactoryGirl

We've found factories to be a better alternative to fixtures. Rather than
defining hardcoded data, factories define generators of sorts, with predefined
logic where necessary. You can override this logic directly when instantiating
the factories in your tests. They look something like this:

```ruby
# spec/factories.rb
FactoryGirl.define do
  factory :link do
    title "Testing Rails"
    url "http://testingrailsbook.com"
  end
end
```

```ruby
# In your test
link = create(:link)

# Or override the title
link = create(:link, title: "TDD isn't Dead!")
```

Factories put the important logic right in your test. They make it easy to see
what is happening at a glance and are more flexible to different scenarios you
may want to set up. While factories can be slower than fixtures, we think the
benefits in flexibility and readability outweigh the costs.

#### Installing FactoryGirl

To install FactoryGirl, add `factory_girl_rails` to your `Gemfile`:

```ruby
group :development, :test do
  ...
  gem "factory_girl_rails"
  ...
end
```

We'll also be using Database Cleaner:

```ruby
group :test do
  ...
  gem "database_cleaner"
  ...
end
```

Install the new gems and create a new file `spec/support/factory_girl.rb`:

` spec/support/factory_girl.rb@944b0967

This file will lint your factories before the test suite is run. That is, it
will ensure that all the factories you define are valid. While not necessary,
this is a worthwhile check, especially while you are learning. It's a quick way
to rest easy that your factories work. Since `FactoryGirl.lint` may end up
persisting some records to the database, we use Database Cleaner to restore the
state of the database after we've linted our factories. We'll cover Database
Cleaner in depth later.

Now, this file won't require itself! In your `rails_helper` you'll find some
commented out code that requires all of the files in `spec/support`. Let's
comment that in so our FactoryGirl config gets loaded:

```ruby
# Uncomment me!
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
```

Last, we need to create our factories file. Create a new file at
`spec/factories.rb`:

```ruby
FactoryGirl.define do
end
```

This is where we'll define our factory in the next section.

#### The test

With FactoryGirl set up, we can write our test. We start with a new file at
`spec/features/user_views_homepage_spec.rb`.

```ruby
require "rails_helper"

RSpec.feature "User views homepage" do
  scenario "they see existing links" do
  end
end
```

We require our `rails_helper` and create the standard feature and scenario
blocks.

```ruby
link = create(:link)
```

To setup our test, we create a link using FactoryGirl's `.create` method, which
instantiates a new `Link` object with our (currently non-existent) factory
definition and persists it to the database.

`.create` is loaded into the global context in `spec/support/factory_girl.rb`:

```
config.include FactoryGirl::Syntax::Methods
```

While we'll be calling `.create` in the global context to keep our code cleaner,
you may see people calling it more explicitly: `FactoryGirl.create`. This is
simply a matter of preference, and both are acceptable.

Now, we'll need to add a factory definition for our `Link` class in
`spec/factories.rb`:

` spec/factories.rb@944b0967:2,5

We define a default title and URL to be created for all links created with
FactoryGirl. We only define defaults for fields that we [validate presence of]. If
you add more than that, your factories can become unmanageable as all of your
tests become coupled to data defined in your factories that isn't a default.
Not following this advice is a common mistake in Rails codebases and leads to
major headaches.

[validate presence of]: https://github.com/thoughtbot/testing-rails/commit/5ed3981619066bb71c1b8f4b17647c57aebd2707#diff-594e2b1fb48290a8f5f695da1c1e9318R2

The specific title and URL is unimportant, so we don't override the factories'
defaults. This allows us to focus on what is important and makes the test easier
to read.

```ruby
visit root_path

expect(page).to have_link link.title, href: link.url
```

Nothing novel here. Visit the homepage and assert that we see the title linking
to the URL.

#### Passing the test

This is left as an exercise for the reader. Feel free to check out the
[associated commit] to see what I did.

[associated commit]: https://github.com/thoughtbot/testing-rails/commit/944b0967232fe7bb623adbb36482ce3f76c7a037
