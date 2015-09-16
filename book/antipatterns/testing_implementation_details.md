## Testing Implementation Details

One metric of a solid test suite is that you shouldn't have to modify your tests
when refactoring production code. If your tests know too much about the
implementation of your code, your production and test code will be highly
coupled, and even minor changes in your production code will require reciprocal
changes in the test suite. When you find yourself refactoring your test suite
alongside a refactoring of your production code, it's likely you've
tested too many implementation details of your code. At this point, your tests
have begun to slow rather than assist in refactoring.

The solution to this problem is to favor testing behavior over implementation.
You should test _what_ your code does, not _how_ it does it. Let's use some code
as an example:

```ruby
class Numeric
  def negative?
    self < 0
  end
end

def absolute_value(number)
  if number.negative?
    -number
  else
    number
  end
end
```

The following is a _bad_ test (not to mention, it doesn't fully test the method):

```ruby
# this is bad

describe "#absolute_value" do
  it "checks if the number is negative" do
    number = 5
    allow(number).to receive(:negative?)

    absolute_value(number)

    expect(number).to have_received(:negative?)
  end
end
```

The above code tests an implementation detail. If we later removed our
implementation of `Numeric#negative?` we'd have to change both our production
code _and_ our test code.

A better test would look like this:

```ruby
describe "#absolute_value" do
  it "returns the number's distance from zero" do
    expect(absolute_value(4)).to eq 4
    expect(absolute_value(0)).to eq 0
    expect(absolute_value(-2)).to eq 2
  end
end
```

The above code tests the interface of `#absolute_value`. By testing just the
inputs and outputs, we can freely change the implementation of the method
without having to change our test case. The nice thing is that if we are
following TDD, our tests will naturally follow this guideline, since TDD
encourages us to write tests for the behavior we expect to see.

### Gotcha

It is occasionally true that testing behavior and testing implementation will
be one and the same. A common case for this is when testing methods that must
delegate to other methods. For example, many service objects will queue up a
background job. Queuing that job is a crucial behavior of the service object,
so it may be necessary to stub the job and assert it was called:

```ruby
describe "Notifier#notify" do
  it "queues a NotifierJob" do
    allow(NotifierJob).to receive(:notify)

    Notifier.notify("message")

    expect(NotifierJob).to have_received(:notify).with("message")
  end
end
```

### Private Methods

As you may have guessed, private methods are an implementation detail. We say
it's an implementation detail, because the consumer of the class will rely on
the public interface, but shouldn't care what is happening behind the scenes.
When you encapsulate code into a private method, the code is not part of the
class's public interface. You should be able to change how the code works (but
not what it does) without disrupting anything that depends on the class.

The benefit of being able to refactor code freely is a huge boon, as long as you
know that the behavior of your class is well tested. While you shouldn't test
your private methods directly, they can and should be tested indirectly by
exercising the code from public methods. This allows you to change the internals
of your code down the road without having to change your tests.

If you feel that the logic in your private methods is necessary to test
independently, that may be a hint that the functionality can be encapsulated in
its own class. At that point, you can extract a new class to test. This has the
added benefit of improved reusability and readability.
