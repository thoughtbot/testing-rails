## Continuous Integration

Tests are a great way to make sure an application is working correctly. However,
they only provide that value if you remember to run them. It's easy to forget to
re-run the test suite after rebasing or to think that everything is fine because
the change you made was so small it couldn't *possibly* break anything (hint: it
probably did).

Enter **continuous integration**, or **CI** for short. Continuous integration is
a service that watches a repository and automatically tries to build the project
and run the test suite every time new code is committed. Ideally it runs on a
separate machine with a clean environment to prevent "works on my machine" bugs.
It should build all branches, allowing you to know if a branch is "green" before
merging it.

There are many CI providers that will build Rails apps and run their test suite
for you. Our current favorite is [CircleCI](https://circleci.com/).

GitHub can run your CI service against commits in a pull request and will
integrate the result into the pull request status, clearly marking it as passing
or failing.

Continuous integration is a great tool for preventing broken code from getting
into `master` and to keep nagging you if any broken code does get there. It is
not a replacement for running tests locally. Having tests that are so slow that
you only run them on CI is a red flag and [should be addressed](#slowtests).

CI can be used for **continuous deployment**, automatically deploying all green
builds of `master`.
