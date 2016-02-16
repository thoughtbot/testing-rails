# Testing Rails

A book about testing Rails applications the thoughtbot way.

## Reading the Book

You can find the current release in a variety of formats under the [release][]
directory. To view older releases, check out a specific Git [tag][tags].

[release]: https://github.com/thoughtbot/testing-rails/tree/master/release
[tags]: https://github.com/thoughtbot/testing-rails/releases

## Providing Feedback

Please provide feedback via [GitHub][].

[GitHub]: https://github.com/thoughtbot/testing-rails/issues

## Paperback

We use [Paperback][] (internal to thoughtbot) for generating eBooks. To build
the book, follow [the instructions for setting up Paperback] and be sure to have
Docker running.

[Paperback]: https://github.com/thoughtbot/paperback
[the instructions for setting up Paperback]:
https://github.com/thoughtbot/paperback#installation

## Building the book

To build the book (for inspecting compiled output):

    $ bin/build

## Releasing an update

We're using tags and releases to track milestones in book updates.

The release script builds the project, moves the built files into
 `/release`, and bumps the git tag:

    $ bin/release

Build a zip to upload to Gumroad and attach it to the GitHub release:

    $ bin/build-zip

## Updating the sample.pdf

Build and upload to <http://thoughtbot.com/testing-rails-sample.pdf> by
  updating the website repo (samples are in public/).

## Contributors

Thank you to all who've [contributed][contributors] so far!

[contributors]: https://github.com/thoughtbot/testing-rails/graphs/contributors
