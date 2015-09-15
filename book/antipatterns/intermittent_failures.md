## Intermittent Failures

Intermittent test failures are one of the hardest kinds of bug to find. Before
you can fix a bug, you need to know why it is happening, and if the bug
manifests itself at seemingly random intervals, this can be especially
difficult. Intermittent failures can happen for a lot of reasons, typically due
to time or from tests affecting other tests.

We usually advise running your tests in a random order. The goal of this is to
make it easy to tell when tests are being impacted by other tests. If your tests
_aren't_ cleaning up after themselves, then they may cause failures in other
tests, intermittently depending on the order the tests happen to be run in. When
this happens, the best way to start diagnosing is to rerun the tests using the
`seed` of the failing test run.

You may have noticed that your tests output something like `Randomized with seed
30205` at the end of each test run. You can use that seed to rerun the tests in
the same "randomized" order: `rspec --seed 30205`. If you want to narrow down
the number of examples that are run, you can use [RSpec
bisect](https://relishapp.com/rspec/rspec-core/v/3-3/docs/command-line/bisect) (
`rspec --seed 30205 --bisect`), which runs the tests in different combinations
to hone in on the one that is causing problems.

Here are some likely candidates to look for when trying to diagnose intermittent
failures:

### Database contamination

Database contamination occurs when writes to the database are not cleaned up
after a single test is run. When the subsequent test is run, the effects of the
first test can cause unexpected output. RSpec has transactional fixtures turned
on by default, meaning it runs each test within a transaction, rolling that
transaction back at the end of the test.

The problem is, tests run with the JavaScript driver are run in a separate
thread which doesn't share a connection to the database. This means that the
test has to commit the changes to the database. In order to return to the
original state, you have to truncate the database, essentially deleting all
records and resetting all indexes. The one downside of this, is that it's a bit
slower than transactions.

As we've mentioned previously, we use Database Cleaner to automatically use
transaction or truncation to reset our database depending on which strategy is
necessary.

### Global state

Whenever you modify global state, be sure to reset it to the original state
after the test is run, _even if the test raises an error_. If the state is never
reset, the modified value can leak into the following tests in the test run.
Here's a common helper file I'll use to set `ENV` variables in my tests:

```ruby
# spec/support/env_helper.rb

module EnvHelper
  def with_env(variable, value)
    old_value = ENV[variable]
    ENV[variable] = value
    yield
  ensure
    ENV[variable] = old_value
  end
end

RSpec.configure do |config|
  config.include EnvHelper
end
```

You can use this in a test, like so:

```ruby
require "spec_helper"

feature "User views the form setup page", :js do
  scenario "after creating a submission, they see the continue button" do
    with_env("POLLING_INTERVAL", "1") do
      form = create(:form)

      visit setup_form_path(form, as: form.user)

      expect(page).not_to have_css "[data-role=continue]"

      submission = create(:submission, form: form)

      expect(page).to have_css "[data-role=continue]"
    end
  end
end
```

You could also use [Climate
Control](https://github.com/thoughtbot/climate_control), a pre-baked solution
that works in a similar fashion.

### Time

Time and time zones can be tricky. Sometimes microseconds can be the difference
between a passing and failing test, and if you've ever run your tests from
different time zones you may have seen failures on assertions about the current
day.

The best way to ensure that the time is what you think it is, is to stub it out
with a known value. Rails 4.1 introduced the `travel_to` helper, which allows
you to stub the time within a block:

```ruby
it "sets submitted at to the current time" do
  form = Form.new

  travel_to Time.now do
    form.submit
    expect(form.reload.submitted_at).to eq Time.now
  end
end
```

If you are on older versions of Rails, you can use
[timecop](https://github.com/travisjeffery/timecop) to control time.
