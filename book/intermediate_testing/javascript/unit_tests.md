### Unit tests

If you have more than just a little jQuery scattered throughout your
application, you are probably going to want to unit test some of it. As with
other things JavaScript, there is an overwhelming amount of choice.
We've had success with both [Jasmine][jasmine] and [Mocha][mocha]. Some
front-end frameworks will push you very strongly towards a particular libary.
For example, Ember is biased towards [Qunit][qunit].

These all come with some way of running the suite via the command-line. You
can then build a custom Rake task that will run both your RSpec and JavaScript
suites. The Rake task can be run both locally and on CI. RSpec provides a `rake
spec` task that you can hook into.

In your `Rakefile`:

```ruby
# the jasmine:ci task is provided by the jasmine gem
task :full_suite, ["jasmine:ci", "spec"]
```

You can also override the default rake task to run both suites with just `rake`:

```ruby
task(:default).clear
task default: ["jasmin:ci", "spec"]
```

[jasmine]: https://jasmine.github.io/
[mocha]: https://mochajs.org/
[qunit]: https://qunitjs.com/
