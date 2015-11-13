## Let, Subject, and Before

RSpec has a few features that we have not yet mentioned, because we find that
they make test suites difficult to maintain. The main offenders are `let`,
`let!`, `subject`, and `before`. They share similar problems, so this section
will use `let` and `let!` as examples. `let` allows you to declare a fixture
that will be automatically defined in all other tests in the same context of the
`let`.

`let` works by passing it a symbol and a block. You are then provided a method
with the same name as the symbol you passed to `let` in your test. When you call
it, RSpec will evaluate and memoize the respective block. Since the block is not
run until you call the method, we say that it is lazy-evaluated. `let!` on the
other hand, will define a method that runs the code in the given block, but it
will always be invoked one time before each test is run.

Here's an example taken from [Hound](https://github.com/thoughtbot/hound):

```ruby
describe RepoActivator, "#deactivate" do
  let(:repo) {
    create(:repo)
  }

  let(:activator) {
    allow(RemoveHoundFromRepo).to receive(:run)
    allow(AddHoundToRepo).to receive(:run).and_return(true)

    RepoActivator.new(github_token: "githubtoken", repo: repo)
  }

  let!(:github_api) {
    hook = double(:hook, id: 1)
    api = double(:github_api, remove_hook: true)
    allow(api).to receive(:create_hook).and_yield(hook)
    allow(GithubApi).to receive(:new).and_return(api)
    api
  }

  context "when repo deactivation succeeds" do
    it "marks repo as deactivated" do
      activator.deactivate

      expect(repo.reload).not_to be_active
    end

    it "removes GitHub hook" do
      activator.deactivate

      expect(github_api).to have_received(:remove_hook)
      expect(repo.hook_id).to be_nil
    end

    it "returns true" do
      expect(activator.deactivate).to be true
    end
  end
end
```

The biggest issue of this code is readability. As with other types of fixtures,
`let` obscures the code by introducing a [Mystery Guest](#fixtures). Having the
test's dependencies declared at the top of the file make it difficult to know
which dependencies are required for each test. If you added more tests to this
test group, they may not all have the same dependencies.

`let` can also lead to [brittle tests](#brittle-tests). Since your tests are
reliant on objects that are created far from the test cases themselves, it's
easy for somebody to change the setup code unaware of how it will effect each
individual test. This issue is compounded when we override definitions in nested
contexts:

```ruby
describe RepoActivator, "#deactivate" do
  let(:repo) {
    create(:repo)
  }

  let(:activator) {
    allow(RemoveHoundFromRepo).to receive(:run)
    allow(AddHoundToRepo).to receive(:run).and_return(true)

    RepoActivator.new(github_token: "githubtoken", repo: repo)
  }

  ...

  context "when repo deactivation succeeds" do
    let(:repo) {
      create(:repo, some_attribute: "some value")
    }

    ...
  end
end
```

In the above scenario, we have overriden the definition of `repo` in our nested
context. While we can assume that a direct call to `repo` will return this
locally defined `repo`, what happens when we call `activator`, which also
depends on `repo` but is declared in the outer context? Does it call the `repo`
that is defined in the same context, or does it call the `repo` that is defined
in the same context of our test?

This code has another, more sneaky problem. If you noticed, there's a subtle use
of `let!` when we declare `github_api`. We used `let!`, because the first and
last example need it to be stubbed, but don't need to reference it in the test.
Since `let!` forces the execution of the code in the block, we've introduced the
possibility for a potential future bug. If we write a new test in this context,
this code will now be run for that test case, even if we didn't intend for that
to happen. This is a recipe for unintentionally slowing down your suite.

If we were to scroll down so that the `let` statements go off the screen,
our examples would look like this:

```ruby
context "when repo deactivation succeeds" do
  it "marks repo as deactivated" do
    activator.deactivate

    expect(repo.reload).not_to be_active
  end

  it "removes GitHub hook" do
    activator.deactivate

    expect(github_api).to have_received(:remove_hook)
    expect(repo.hook_id).to be_nil
  end

  it "returns true" do
    expect(activator.deactivate).to be true
  end
end
```

We now have no context as to what is happening in these tests. It's impossible to
tell what your test depends on, and what else is happening behind the scenes. In
a large file, you'd have to go back and forth between your tests and `let`
statements, which is slow and error prone. In poorly organized files, you might
even have multiple levels of nesting and dispersed `let` statements, which make
it almost impossible to know which `let` statements are associated with each
test.

So what's the solution to these problems? Instead of using RSpec's DSL, you can
use plain old Ruby. Variables, methods, and classes! A refactored version of the
code above might look like this:

```ruby
describe RepoActivator, "#deactivate" do
  context "when repo deactivation succeeds" do
    it "marks repo as deactivated" do
      repo = create(:repo)
      activator = build_activator(repo: repo)
      stub_github_api

      activator.deactivate

      expect(repo.reload).not_to be_active
    end

    it "removes GitHub hook" do
      repo = create(:repo)
      activator = build_activator(repo: repo)
      github_api = stub_github_api

      activator.deactivate

      expect(github_api).to have_received(:remove_hook)
      expect(repo.hook_id).to be_nil
    end

    it "returns true" do
      activator = build_activator
      stub_github_api

      result = activator.deactivate

      expect(result).to be true
    end
  end

  def build_activator(token: "githubtoken", repo: build(:repo))
    allow(RemoveHoundFromRepo).to receive(:run)
    allow(AddHoundToRepo).to receive(:run).and_return(true)

    RepoActivator.new(github_token: token, repo: repo)
  end

  def stub_github_api
    hook = double(:hook, id: 1)
    api = double(:github_api, remove_hook: true)
    allow(api).to receive(:create_hook).and_yield(hook)
    allow(GithubApi).to receive(:new).and_return(api)
    api
  end
end
```

By calling these Ruby constructs directly from our test, it's easy to see what
is being generated in the test, and if we need to dig deeper into what's
happening, we can follow the method call trail all the way down. In effect,
we've optimized for communication rather than terseness. We've also avoided
implicitly adding unnecessary dependencies to each of our tests.

Another thing to note is that while we build the activator and GitHub API stub
in methods external to our tests, we do the assignment within the tests
themselves. Memoizing the value to an instance variable in the external method
is simply a reimplementation of `let`, and suffers the same pitfalls.
