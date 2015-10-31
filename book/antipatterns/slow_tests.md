## Slow tests

As applications grow, test suites naturally and necessarily get slower.  The
longer the test suite, the less you will run it. The more often you can run your
tests, the more valuable they are because you can catch bugs faster than you
otherwise would have. As a baseline, after every line of code that I write, I
try to run its respective test. I always run my entire test suite before
submitting pull requests and after rebasing. As you can imagine, this leads to
running your tests frequently. If it's a chore to run your tests you aren't
going to run them, and they quickly become out of date. At that point, you may
as well not have written them in the first place.

While continuous integration is a good tool to double check that your suite
passes in a public way, it should not be the _only_ place that the entire suite
is run. If you have to wait to see if your tests pass on CI, this will seriously
slow down the development of new features.

Here are some things to think about when trying to write a fast test suite:

### Use profiling to find the slowest tests

The easiest way to find the worst offenders is to profile your suite. Running
`rspec` with the `--profile` flag will output the 10 slowest tests (`--profile
4` will output the 4 slowest). You can add this flag to your `.rspec` file to
output with every run.

### Have a fast spec helper

When you repeatedly run individual tests and test files, you may notice that a
majority of the time running the tests isn't spent running the test itself, but
is actually spent loading your application's dependencies. One of the main
culprits here is Rails. With a large application, loading your entire
application can take seconds, and that's a long time to wait if you want to run
your tests after every line of code you change.

The nice thing is, some of the tests you write won't depend on Rails at all.
Depending on how you architect your code, this could be a lot of tests. We favor
writing a lot of small objects called POROs, or Plain Old Ruby Objects (objects
that aren't backed by ActiveRecord). Since these objects don't depend on Rails,
we can avoid loading it when running just these tests.

For this reason, rspec-rails 3.0 introduced multiple default spec helpers. When
you initialize a Rails app with RSpec, it creates a `rails_helper.rb` which
loads Rails and a `spec_helper.rb` which doesn't. When you don't need Rails, or
any of its dependencies, require your `spec_helper.rb` for a modest time
savings.

### Use an application preloader

Rails 4.1 introduced another default feature that reduces some of the time it
takes to load Rails. The feature is bundled in a gem called
[Spring](https://github.com/rails/spring), and classifies itself as an
application preloader. An application preloader automatically keeps your
application running in the background so that you don't have to load it
repeatedly for various different tasks or test runs. Spring is available for
many tasks by default, such as rake tasks, migrations, and TestUnit tests.

To use spring, you can prefix these commands with the `spring` command, e.g.
`spring rake db:migrate`. The first time you run the command, Spring will start
your application. Subsequent uses of Spring will have already booted your
application, so you should see some time savings. You can avoid having to type
the `spring` command prefix by installing the Spring binstubs:

```
bundle exec spring binstub --all
```

To use spring with RSpec, you'll have to install the
[spring-commands-rspec](https://github.com/jonleighton/spring-commands-rspec)
gem and run `bundle exec spring binstub rspec`.

If you are on older versions of Rails, you can manually add `spring` to your
Gemfile, or use other application preloaders such as
[Zeus](https://github.com/burke/zeus).

### Only persist what is necessary

One of the most common causes of slow tests is excessive database interaction.
Persisting to the database takes far longer than initializing objects in memory,
and while we're talking fractions of a second, each of these round trips to the
database adds up when running your entire suite.

When you initialize new objects, try to do so with the least overhead. Depending
on what you need, you should choose your initialization method in this order:

* `Object.new` - initializes the object without FactoryGirl. Use this when you
  don't care about any validations or default values.
* `FactoryGirl.build_stubbed(:object)` - initializes the object with
  FactoryGirl, setting up default values and associates records using the
  `build_stubbed` method. Nothing is persisted to the database.
* `FactoryGirl.build(:object)` - initializes the object with FactoryGirl,
  setting up default values and persisting associated records with `create`.
* `FactoryGirl.create(:object)` - initializes and persists the object with
  FactoryGirl, setting up default values and persisting associated records with
  `create`.

Another thing to look out for is factory definitions with more associations than
are necessary for a valid model. We talk about this more in [Using Factories
Like Fixtures](#using-factories-like-fixtures).

### Move sad paths out of feature specs

Feature specs are slow. They have to boot up a fake browser and navigate around.
They're particularly slow when using a JavaScript driver which incurs even more
overhead. While you do want a feature spec to cover every user facing feature
of your application, you also don't want to duplicate coverage.

Many times, feature specs are written to cover both _happy paths_ and _sad
paths_. In an attempt to mitigate duplicate code coverage with slower tests,
we'll often write our happy path tests with feature specs, and sad paths with
some other medium, such as request specs or view specs. Finding a balance
between too many and too few feature specs comes with experience.

### Don't hit external APIs

External APIs are slow and unreliable. Furthermore, you can't access them
without an internet connection and many APIs have rate limits. To avoid all
these problems, you should _not_ be hitting external APIs in the test
environment. For most APIs you should be writing fakes or stubbing them out. At
the very least, you can use the [VCR](https://github.com/vcr/vcr) gem to cache
your test's HTTP requests. If you use VCR, be sure to auto-expire the tests
once every one or two weeks to ensure the API doesn't change out from under you.

If you want to be extra certain that you are testing against the real API, you
can configure your test suite to hit the API on CI only.

### Delete tests

Sometimes, a test isn't worth it. There are always tradeoffs, and if you have a
particularly slow test that is testing a non-mission critical feature, or a
feature that is unlikely to break, maybe it's time to throw the test out if it
prevents you from running the suite.
