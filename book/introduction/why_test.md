## Why test?

As software developers, we are hired to write code that _works_.
If our code doesn't work, we have failed.

So how do we ensure correctness?

One way is to manually run your program after writing it. You write a new
feature, open a browser, click around to see that it works, then continue adding
more features. This works while your application is small, but at some point
your program has too many features to keep track of. You write some new code,
but it unexpectedly breaks old features and you might not even know it. This is
called a **regression**. At one point your code worked, but you later introduced
new code which broke the old functionality.

A better way is to have the computer check our work. We write software to
automate our lives, so why not write programs to test our code as well?
**Automated tests** are scripts that output whether or not your code works
as intended. They verify that our program works now, and will continue to work
in the future, without humans having to test it by hand. Once you write a test,
you should be able to reuse it for the lifetime of the code it tests, although
your tests can change as expectations of your application change.

Any large scale and long lasting Rails application should have a comprehensive
test suite. A **test suite** is the collection of tests that ensure that your
system works. Before marking any task as "complete" (i.e. merging into the
`master` branch of your Git repository), it is imperative to run your entire
test suite to catch regressions. If you have written an effective test suite,
and the test suite passes, you can be confident that your entire application
behaves as expected.

A test suite will be comprised of many different kinds of tests, varying in
scope and subject matter. Some tests will be high level, testing an entire
feature and walking through your application as if they were a real user. Others
may be specific to a single line of code. We'll discuss the varying flavors of
tests in detail throughout this book.

### Saving Time and Money

At the end of the day, testing is about saving time and money. Automated tests
catch bugs sooner, preventing them from ever being deployed. By reducing the
manpower necessary to test an entire system, you quickly make up the time it
takes to implement a test in the first place.

Automated tests also offer a quicker feedback loop to programmers, as they don't
have to walk through every path in their application by hand. A well written
test can take milliseconds to run, and with a good development setup you don't
even have to leave your editor. Compare that to using a manual approach a
hundred times a day and you can save a good chunk of time. This enables
developers to implement features faster because they can code confidently
without opening the browser.

When applications grow without a solid test suite, teams are often discouraged
by frequent bugs quietly sneaking into their code. The common solution is
to hire dedicated testers; a Quality Assurance (QA) team. This is an expensive
mistake. As your application grows, now you have to scale the number of hands on
deck, who will never be as effective as automated tests at catching regressions.
QA increases the time to implement features, as developers must communicate back
and forth with another human. Compared to a test suite, this is costly.

This is not to say that QA is completely useless, but they should be hired in
addition to a good test suite, not as a replacement. While manual testers are
not as efficient as computers at finding regressions, they are much better at
validating subjective qualities of your software, such as user interfaces.

### Confidence

Having a test suite you can trust enables you do things you would otherwise not
be able to. It allows you to make large, sweeping changes in your codebase
without fearing you will break something. It gives you the confidence to deploy
code at 5pm on a Friday. Confidence allows you to move faster.

### Living Documentation

Since every test covers a small piece of functionality in your app, they serve
as something more than just validations of correctness. Tests are a great form
of living documentation. Since comments and dedicated documentation are
decoupled from your code, they quickly go stale as you change your application.
Tests must be up to date, or they will fail. This makes them the second best
source of truth, after the code itself, though they are often easier to read.
When I am unsure how a piece of functionality works, I'll look first at the test
suite to gain insight into how the program is supposed to behave.
