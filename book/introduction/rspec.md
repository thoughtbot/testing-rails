## RSpec

We'll need a testing framework in order to write and run our tests. The
framework we choose determines the format we use to write our tests, the
commands we use to execute our tests, and the output we see when we run our
tests.

Examples of such frameworks include Test::Unit, Minitest, and RSpec. Minitest is
the default Rails testing framework, but we use RSpec for the mature test runner
and a syntax that encourages human readable tests. RSpec provides a Domain
Specific Language (DSL) specifically written for test writing that makes reading
and writing tests feel more natural. The gem is called RSpec, because the tests
read like specifications. They describe _what_ the software does and how the
interface should behave. For this reason, we refer to RSpec tests as _specs_.

While this book uses RSpec, the content will be based in theories and practice
that you can use with any framework.

### Installation

When creating new apps, we run `rails new` with the `-T` flag to avoid creating
any Minitest files. If you have an existing Rails app and forgot to pass that
flag, you can always remove `/test` manually to avoid having an unused folder in
your project.

Use [`rspec-rails`] to install RSpec in a Rails app, as it configures many of
the things you need for Rails testing out of the box. The plain ol'
[`rspec`] gem is used for testing non-Rails programs.

[`rspec-rails`]: https://github.com/rspec/rspec-rails
[`rspec`]: https://github.com/rspec/rspec

Be sure to add the gem to *both* the `:development` and `:test` groups in your
`Gemfile`. It needs to be in `:development` to expose Rails generators and rake
tasks at the command line.

```ruby
group :development, :test do
  gem 'rspec-rails', '~> 3.0'
end
```

Bundle install:

```
bundle install
```

Generate RSpec files:

```
rails generate rspec:install
```

This creates the following files:

* [`.rspec`](https://github.com/thoughtbot/testing-rails/blob/b86752a0690a2800c6f57e23974bfe11c8b5fe28/example_app/.rspec)

    Configures the default flags that are passed when you run `rspec`. The line
    [`--require spec_helper`] is notable, as it will automatically require the spec
    helper file for every test you run.

[`--require spec_helper`]: https://github.com/thoughtbot/testing-rails/blob/b86752a0690a2800c6f57e23974bfe11c8b5fe28/example_app/.rspec#L2

* [`spec/spec_helper.rb`](https://github.com/thoughtbot/testing-rails/blob/b86752a0690a2800c6f57e23974bfe11c8b5fe28/example_app/spec/spec_helper.rb)

    Further customizes how RSpec behaves. Because this is loaded in every test,
    you can guarantee it will be run when you run a test in isolation. Tests run
    in isolation should run near instantaneously, so be careful adding any
    dependencies to this file that won't be needed by every test.  If you have
    configurations that need to be loaded for a subset of your test suite,
    consider making a separate helper file and load it only in those files.

    At the bottom of this file is a comment block the RSpec maintainers suggest
    we enable for a better experience. We agree with most of the customizations.
    I've [uncommented them], then [commented out a few specific settings] to
    reduce some noise in test output.

[uncommented them]: https://github.com/thoughtbot/testing-rails/commit/572ddcebcf86c74687ced40ddb0aad234f6e9657
[commented out a few specific settings]: https://github.com/thoughtbot/testing-rails/commit/1c5e29def9e64d4e67abb5a0867c67348468ab5b


* [`spec/rails_helper.rb`](https://github.com/thoughtbot/testing-rails/blob/b86752a0690a2800c6f57e23974bfe11c8b5fe28/example_app/spec/rails_helper.rb)

    A specialized helper file that loads Rails and its dependencies. Any file that
    depends on Rails will need to require this file explicitly.

The generated spec helpers come with plenty of comments describing what each
configuration does. I encourage you to read those comments to get an idea of how
you can customize RSpec to suit your needs. I won't cover them as they tend to
change with each RSpec version.
