## Characteristics of an Effective Test Suite

The most effective test suites share the following characteristics.

### Fast

The faster your tests are, the more often you can run them. Ideally, you can run
your tests after every change you make to your codebase. Tests give you the
feedback you need to change your code. The faster they are the faster you can
work and the sooner you can deliver a product.

When you run slow tests, you have to wait for them to complete. If they are slow
enough, you may even decide to take a coffee break or check Twitter. This
quickly becomes a costly exercise. Even worse, you may decide that running tests
is such an inconvenience that you stop running your tests altogether.

### Complete

Tests cover all public code paths in your application. You should not be able to
remove publicly accessible code from your production app without seeing test
failures. If you aren't sufficiently covered, you can't make changes and be
confident they won't break things. This makes it difficult to maintain your
codebase.

### Reliable

Tests do not wrongly fail or pass. If your tests fail intermittently or you get
false positives you begin to lose confidence in your test suite. Intermittent
failures can be difficult to diagnose. We'll discuss some common symptoms later.

### Isolated

Tests can run in isolation. They set themselves up, and clean up after
themselves. Tests need to set themselves up so that you can run tests
individually. When working on a portion of code, you don't want to have to waste
time running the entire suite just to see output from a single test. Tests that
don't clean up after themselves may leave data or global state which can lead to
failures in other tests when run as an entire suite.

### Maintainable

It is easy to add new tests and existing tests are easy to change. If it is
difficult to add new tests, you will stop writing them and your suite becomes
ineffective. You can use the same principles of good object oriented design to
keep your codebase maintainable. We'll discuss some of them later in this book.

### Expressive

Tests are a powerful form of documentation because they are always kept up to
date. Thus, they should be easy enough to read so they can serve as said
documentation. During the refactor phase of your TDD cycle, be sure you remove
duplication and abstract useful constructs to keep your test code tidy.
