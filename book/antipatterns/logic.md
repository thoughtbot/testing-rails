## Using logic to generate tests

As programmers, one of the first refactorings we are taught is **DRY**, don't
repeat yourself. Although the principle is to prevent the duplication of
_concepts_ in a code base, many developers try to eliminate _duplicated lines or
characters_ which is not necessarily the same thing.

In tests in particular, trying to remove all duplication can lead you down a
dark path. Taken to an extreme, it leads to unreadable and unchangeable specs.

Consider the following "clever" code:

```ruby
tests = [
  { value: 1, return: false },
  { value: 2, return: true },
  { value: 3, return: false },
  { value: 4, return: true },
]

tests.each do |test|
  it "is #{test[:return]} when given #{test[:value]}" do
    validator = Validator.new(test[:value])

    expect(validator.valid?).to eq test[:return]
  end
end
```

Reading this is not straightforward. You spend a lot of time understanding the
test-generation logic instead of the test cases themselves.

It is also very **brittle**. When some use cases start changing but others
don't, the whole structure will grow to be very complex as you try to express
concepts such as conditionals, optional values, and special cases.

Debugging failures is difficult in this scenario as all failures will break on
the same line. If you try putting a `binding.pry` in there, it will stop for
each of the cases.

Generating tests can also hide a deeper design problem. Why do you need so many
similar tests that generating them from a data structure seemed like a good
solution? Is it reflecting a lot of conditionals and special cases in your
production code?

When you are trying to build a modular test suite that can scale and adapt to
change, avoid being "clever" and trying to meta-program your tests in the name
of DRY.
