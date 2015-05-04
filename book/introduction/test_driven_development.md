## Test Driven Development

Automated tests are likely the best way to achieve confidence in a growing
codebase. To amplify that confidence and achieve bigger wins in time savings and
code cleanliness, we recommend writing code using a process called **Test Driven
Development** (TDD). TDD is a process that uses tests to _drive_ the design and
development of your application. It begins with a development cycle called
**Red, Green, Refactor**.

### Red, Green, Refactor

Red, Green, Refactor is a series of steps that lead you through developing a
given feature or fixing a bug:

#### Red

Write a test that covers the functionality you would like to see implemented.
You don't have to know what your code looks like at this point, you just have to
know what it will do. Run the test. You should see it fail. Most test runners
will output red for failure and green for success. While we say "failure" do not
take this negatively. It's a good sign! By seeing the test fail first, we know
that once we make it pass, our code works.

#### Green

Read the error message from the failing test, and write as little code as
possible to fix the current error message. By only writing enough code to see
our test pass, we tend to write less code as a whole. Continue this process
until the test passes. This may involve writing intermediary features covering
lower level functionality which require their own Red, Green, Refactor cycle.

Do not focus on code quality at this point. Be shameless! We simply want to get
our new test passing. This may involve returning literal values from methods,
which will force you to write additional tests to cover all cases.

#### Refactor

Clean up your code, reducing any duplication you may have introduced. This
includes your code _as well as your tests_. Treat your test suite with as much
respect as you would your live code, as it can quickly become difficult to
maintain if not handled with care. You should feel confident enough in the tests
you've written that you can make your changes without breaking anything.

![TDD Cycle](../images/tdd-cycle.png)

### TDD Approaches

When solving problems with TDD, you must decide where to start testing your
code. Should you start from a high level, testing how the user interacts with
the system, then drill down to the nitty gritty? Or, should you begin with a low
level design and progress outwards to the final feature? The answer to this
depends, and will vary person-to-person and feature-to-feature.

#### Outside-In Development

Outside-In Development starts from the highest level of abstraction first.
Typically, this will be from the perspective of the user walking through the
application in their browser and interacting with elements on the page. We call
this an acceptance test, as it ensures that the behavior of the program is
acceptable to the end user.

As we develop the feature, we'll gradually need to implement more granular
functionality, necessitating intermediate level and lower level tests. These
lower level tests may check a single conditional or return value.

By working inwards instead of outwards, you ensure that you never write more
code than necessary, because there is a clear end. Once the acceptance test
is green, there is no more code to write!

Working outside-in is desirable when you have a good understanding of the
problem, and have a rough understanding of how the interface and code will work
ahead of time. Because you are starting from a high level, your code will not
work until the very end, however your first test will guide your design all the
way to completion. You have to trust that your test will bring you there
successfully.

#### Inside-Out Development

Sometimes you don't know what your end solution will look like, so it's better
to use an inside-out approach. An inside-out approach helps you build up your
code component by component. At each step of the way you will get a larger
piece of the puzzle working and your program will be fully functioning at the
end of each step. By building smaller parts, one at a time, you can change
directions as you get to higher-level components after you build a solid
lower-level foundation.

### Test Driven vs. Test First

Just because you write your test first, does not mean you are using test driven
development. While following the Red, Green, Refactor cycle, it's important to
write code only in response to error messages that are provided by test
failures. This will ensure that you do not overengineer your solution or
implement features that are not tested.

It's also important not to skip the refactor step. This is one of the most
important parts of TDD, and ensures that your code is maintainable and easy to
change in the future.

### Benefits of TDD

#### Confidence

When it comes down to it, TDD is all about confidence. By writing tests _after_
your production code, it's all too easy to forget to test a specific code path.
Writing your tests first and only writing code in response to a failing test,
you can trust that all of our production code is covered. This confidence gives
you power to quickly and easily change your code without fear of it breaking.

#### Time Savings

Consider automated tests an investment. At first, you will add time by writing
tests you would otherwise not be writing. However, most real applications don't
stay the same; they grow. An effective test suite will keep your code honest,
and save you time debugging over the lifetime of the project. The time savings
grow as the project progresses.

TDD can also lead to time savings over traditional testing. Writing your test up
front gives you useful error messages to follow to a finished feature. You save
time thinking of what to do next, because your test tells you!

#### Flow

It isn't uncommon for developers to reach a state of "flow" when developing
with TDD. Once you write your test, the test failures continuously tell you what
to do next, which can almost make programming seem robotic.

#### Improved Design

That TDD itself improves design is arguable (and many have argued it). In
reality, a knowledge of object oriented design principles paired with TDD
aids design. TDD helps you recognize coupling up front. Object oriented design
principles, like dependency injection, help you write your code in ways that
reduce this coupling, making your code easier to test. It turns out that code
that is easy to test happens to align with well structured code. This makes
perfect sense, because our tests run against our code and good code is reusable.

### A Pragmatic Approach

There's a lot of dogmatism surrounding the exercise of TDD. We believe that TDD
is often the best choice for all the reasons above; however, you must always
consider the tradeoffs. Sometimes, TDD doesn't make sense or simply isn't worth
it. In the end, the most important thing is that you can feel confident that
your program works as it should. If you can achieve that confidence in other
ways, that's great!

Here are some reasons you might _not_ test drive, or even test, your code:

* The feature you are trying to implement is outside your wheelhouse, and you
  want to code an exploratory version before you can write your test. We call a
  quick implementation like this a spike. After writing your spike, you may
  then choose to implement the associated test. If you implement the test after
  your production code, you should at the very least toggle some code that would
  make it fail in an expected way. This way, you can be certain it is testing the
  correct thing.  Alternatively, you may want to start from scratch with your new
  knowledge and implement it as part of a TDD cycle.
* The entire program is small or unlikely to change. If it's small enough to test
  by hand efficiently, you may elect to forego testing.
* The program will only be used for a short time. If you plan to throw out the
  program soon, it will be unlikely to change enough to warrant regression
  testing, and you may decide not to test it.
* You don't care if the program doesn't behave as expected. If the program is
  unimportant, it may not be worth testing.
