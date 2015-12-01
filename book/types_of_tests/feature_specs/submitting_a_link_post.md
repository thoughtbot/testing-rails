### Submitting a link post

For our first feature, we're going to allow users to create a link post. To do
this they'll have to click on a link from the home page, fill in the title and
URL of the link, and click "Submit". We'll test that once they do all that, they
see the title they entered on the page, and it should link to the URL they
provided.

As we're using TDD, we'll start with a test describing the functionality we'd
like to see. Let's start with some pseudocode:

```
As a user
When I visit the home page
And I click "Submit a link post"
And I fill in my title and URL
And I click "Submit"
Then I should see the title on the page
And it should link to the given URL
```

One thing to note is that we start our description with _who_ the end user is
for this test. Our app will only have a single role, so it's safe to use `user`,
however many applications will need to differentiate unauthenticated users
(often visitors), admins, or domain specific users roles (like a _coach_ or
_player_).

#### Capybara

In order for our tests to be able to interact with the browser, we have to
install a gem called [Capybara]. Capybara is an API for interacting with the
browser. It provides methods to visit pages, fill in forms, click buttons, and
more.

[Capybara]: https://github.com/jnicklas/capybara

Add it to your Gemfile and `bundle install`:

```ruby
gem "capybara"
```

Require it from your `rails_helper`:

```ruby
require "capybara/rails"
```

#### The test

With that installed, we're ready to write our spec. Take a look at the completed
version. We'll go through it line by line:

` spec/features/user_submits_a_link_spec.rb@c20b7009

Create a new file at `spec/features/user_submits_a_link_spec.rb`.

We'll first require our `rails_helper.rb`, as this will include our Rails
environment and Capybara:

```ruby
require "rails_helper"
```

Next, our feature block:

```ruby
RSpec.feature "User submits a link" do
  ...
end
```

`.feature` is a method that's provided by Capybara. By using it, you have access
to all of Capybara's methods for interacting with the page. You may see
examples elsewhere calling `.feature` in the global context. This is
because old versions of RSpec used monkeypatching to define top level methods on
`main` and `Module`. We disabled this functionality by [commenting in]
`config.disable_monkey_patching!`, as this will be the default functionality in
future versions of RSpec.

[commenting in]: https://github.com/thoughtbot/testing-rails/blob/e03ef3ca8150d8d28c4cdf760f53d11070447b67/example_app/spec/spec_helper.rb#L53

`.feature` takes a string, which you use to describe your feature. We'll usually
name this the same thing as we named our file and create a new file for every
feature. It gets printed out when we run our specs in `documentation` format.

Inside our feature block, we have a `#scenario` block:

```ruby
scenario "they see the page for the submitted link" do
  ...
end
```

This is the container for a single specification. It describes one potential
outcome of the user creating a link. Like the feature block, we pass it a string
which we'll see in our output when we run our spec. The name for the scenario
should be a continuation of the string used for the feature block. When read
together, they should construct a sentence-like structure so that they read well
when we run our specs.

Now for the spec itself!

We first define a couple variables for our title and URL:

```ruby
link_title = "This Testing Rails book is awesome!"
link_url = "http://testingrailsbook.com"
```

Next, visit the homepage:

```ruby
visit root_path
```

Pretty straightforward. `visit` is a method provided by Capybara which will
visit `root_path` as defined by your application. Astute readers will realize
that we have not yet defined `root_path`. `root_path` is undefined, because
this is a brand new application. We're making this up, as we expect there to be
some root route of the application, and we know enough about Rails to know that
Rails convention will name it `root_path` once it is defined.

Use Capybara to click a link. This link will bring us to a new page to fill in
our form:

```ruby
click_on "Submit a new link"
```

Fill in the form fields:

```ruby
fill_in "link_title", with: link_title
fill_in "link_url", with: link_url
```

If you guessed that `#fill_in` was from Capybara, you'd be right! `#fill_in`
finds a method by its name, id, or label and fills it in with the given text. In
this case, we're using the ids `link_title` and `link_url`. While we are using
ids, note that Capybara does not expect you to add a `#` to the beginning of
your id as you would with CSS.

The fields we are looking for don't exist yet, but they will soon. We're using
Rails convention over configuration here to guess what the fields are going to
be called. We know that Rails gives ids to all fields by joining the model name
and the field name. As long as we don't customize those, we can use them to our
advantage.

Even if you didn't know that, once we get around to running the test, you'd see
it fail because it couldn't find a field with that name, id, or label. At that
point, you could open the page in your browser, inspect the element to see what
the id is for real, and replace it here.

With the fields filled in, we can submit the form!

```ruby
click_on "Submit!"
```

And, finally, the assertion:

```ruby
expect(page).to have_link link_title, href: link_url
```

There's a lot going on here, including some "magic", so let's go through each of
the components. While this syntax may look strange, remember that RSpec is just
Ruby code. This could be rewritten as such:

```ruby
expect(page).to(have_link(link_title, { href: link_url }))
```

`#expect` is an RSpec method that will build an assertion. It takes one value,
which we will run an assertion against. In this case it's taking the `page`
object, which is a value provided by Capybara that gives access to the currently
loaded page. To run the assertion, you call `#to` on the return value of
`#expect` and pass it a **matcher**. The matcher is a method that returns truthy
or falsy when run through our assertion. The matcher we've passed here is
`#have_link`. `#have_link` comes from Capybara, and returns true if it finds a link
with the given text on the page. In this case we also pass it a `href` option so
it checks against the link's URL.

So now for the magic. `#have_link` doesn't actually exist. RSpec defines
matchers automatically for methods that start with `has_` and end with `?`.
Capybara defines the method `#has_link?` on the `page` object, so we could think
of this whole line as raising an error if `page.has_link?(...)` returns false.
RSpec will automatically look for the method `#has_link?` when it sees
`#have_link`.

If you've found all this a bit complex, don't worry. How it works is less
important than being able to write assertions using the syntax. We'll be writing
a lot of tests, so the syntax will soon become familiar.

Take a look at the [rspec-expectations] gem to see all of the built-in matchers.

[rspec-expectations]: https://github.com/rspec/rspec-expectations

#### Running our spec

Now that our spec is written, we have to run it! To run it, find your command
line and enter `rspec`. `rspec` will look in our `spec` directory and run all of
the files that end in `_spec.rb`. For now, that's a single file and a single
test.

You should see something like this:

```
User submits a link
  they see the page for the submitted link (FAILED - 1)

Failures:

  1) User submits a link they see the page for the submitted link
     Failure/Error: visit root_path
     NameError:
       undefined local variable or method `root_path' for
         #<RSpec::ExampleGroups::UserSubmitsALink:0x007f9a2231fe98>
       ./spec/features/user_submits_a_link_spec.rb:8:in
         `block (2 levels) in <top (required)>'

Finished in 0.00183 seconds (files took 2.53 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/features/user_submits_a_link_spec.rb:4 # User submits a link they
  see the page for the submitted link

Randomized with seed 5573
```

Let's go through this bit by bit:

```
User submits a link
  they see the page for the submitted link (FAILED - 1)
```

This is the summary of all the tests we ran. It uses the names provided in our
`.feature` and `#scenario` block descriptions. Note that here we read these names
together, which is why we wrote them to read nicely together. We see that the
scenario `they see the page for the submitted link` failed.

The format we see here is called `documentation` and is due to our
configuration in our `spec_helper.rb`. When we run a single spec file, it gives
the output it an expressive format. When we run multiple spec files, this format
can become cumbersome with all the output, so it uses a more concise `dot`
syntax. We'll see that soon.

```
Failures:

  1) User submits a link they see the page for the submitted link
     Failure/Error: visit root_path
     NameError:
       undefined local variable or method `root_path' for
         #<RSpec::ExampleGroups::UserSubmitsALink:0x007f9a2231fe98>
       ./spec/features/user_submits_a_link_spec.rb:8:in
         `block (2 levels) in <top (required)>'
```

This section outlines all of the failures. You will see one failure for each
spec that failed. It outputs the error message, the line that failed, and the
backtrace. We'll look at this in more detail in a second.

```
Finished in 0.00183 seconds (files took 2.53 seconds to load)
1 example, 1 failure
```

Next is a summary of the tests that were run, giving you the total time to run
and the number of tests that were run and that failed.

```
Failed examples:

rspec ./spec/features/user_submits_a_link_spec.rb:4 # User submits a link they
see the page for the submitted link
```

This section outputs the command to run each of the failing specs, for easy copy
and pasting. If you initially run your entire suite with `rspec` and want to
focus in on a single failing test, you can copy this line and enter it into your
terminal to run just that spec. `rspec` takes one or multiple files and will
even parse line numbers as you see above by passing the filename with the line
number at the end (`rspec ./path/to/file:5` if you wanted to run the spec on
line `5`).

```
Randomized with seed 5573
```

Finally, we see the seed we ran our specs with. We run our specs in a random
order to help diagnose specs that may not clean up after themselves properly.
We'll discuss this in more detail in our section on intermittent failures.

#### Passing our test

Now that we know how to read the RSpec output, let's pass our test. To do this,
we'll read the error messages one at a time and write only enough code to make
the current error message pass.

The first error we saw looked like this:

```
Failure/Error: visit root_path
NameError:
  undefined local variable or method `root_path' for
    #<RSpec::ExampleGroups::UserSubmitsALink:0x007f9a2231fe98>
  ./spec/features/user_submits_a_link_spec.rb:8:in
    `block (2 levels) in <top (required)>'
```

It looks like `root_path` is undefined. This helper method comes from Rails when
you define the route in `config/routes.rb`. We want our homepage to show all of
the links that have been submitted, so it will point to the `index` action of
our `LinksController`:

```ruby
root to: "links#index"
```

This is the smallest amount of code we can write to fix that error message.
Run the test again:

```
Failure/Error: visit root_path
ActionController::RoutingError:
  uninitialized constant LinksController
```

Okay, we need to define our `LinksController`. In
`app/controllers/links_controller.rb`:

```ruby
class LinksController
end
```

Define the controller class. We get this failure:

```
Failure/Error: visit root_path
NoMethodError:
  undefined method `action' for LinksController:Class
```

Hmm, so this one's a bit more cryptic. It's saying that `action` is undefined
for our new `LinksController` class. This one requires a bit of Rails knowledge
to debug. If you are familiar with Rails, you know that `action` is the word we
use to refer to a routable method, specific to controllers. So, what makes a
controller different from other classes? Well, it needs to inherit from
`ApplicationController`.

```ruby
class LinksController < ApplicationController
```

Run the test again:

```
Failure/Error: visit root_path
AbstractController::ActionNotFound:
  The action 'index' could not be found for LinksController
```

Okay, let's define that method in our controller (remember that `action` is
Rails lingo for a method in a controller that can be routed to):

```ruby
def index
end
```

```
Failure/Error: visit root_path
ActionView::MissingTemplate:
  Missing template links/index, application/index with {:locale=>[:en],
    :formats=>[:html], :variants=>[], :handlers=>[:erb, :builder, :raw, :ruby,
    :coffee]}. Searched in:
      * "/Users/jsteiner/code/thoughtbot/testing-behind/app/views"
```

We're missing our template! It tells us all the places it looked and the formats
it looked for. In this case it's looking for an HTML template at `links/index`.

We can create an empty file there for now:

```
mkdir app/views/links
touch app/views/links/index.html.erb
```

Rerun the test:

```
Failure/Error: click_on "Submit a new link"
Capybara::ElementNotFound:
  Unable to find link or button "Submit a new link"
```

`app/views/links/index.html.erb` needs a link that reads "Submit a new link". We
know it's going to go to our new link page:

```
<%= link_to "Submit a new link", new_link_path %>
```

The new failure:

```
Failure/Error: visit root_path
ActionView::Template::Error:
  undefined local variable or method `new_link_path' for
    #<#<Class:0x007ff23228ee58>:0x007ff232226088>
```

Now we're missing a route for new new link page. Define it in
`config/routes.rb`:

```ruby
resources :links, only: [:new]
```

Note here that we limit which routes are created with `only`. This will prevent
us from having routes that we don't yet support.

Rerunning the test we get a familiar error.

```
Failure/Error: click_on "Submit a new link"
AbstractController::ActionNotFound:
  The action 'new' could not be found for LinksController
```

At this point, I hope you understand the process we use to develop our features.
You may now understand why having fast tests is important, as you can see we run
them a lot!

Now, do we really run them after every single small code change? Sometimes. Not
always. As you become more experienced with TDD, you'll find that you can predict
the output your tests will give as you develop a feature. Once you can do that,
you can skip some test runs while still only writing code to pass the test that
would have appeared. This allows you to practice TDD while saving some time.
However, it is imperative that you only write code in response to the test that
would have failed. If you can't accurately predict what failure message you'll
see, you should run the tests.

I'll leave the implementation of the rest of this feature as an exercise for the
reader. Take a peak at [my commit] if you get stuck.

[my commit]: https://github.com/thoughtbot/testing-rails/commit/c20b7009e46454070e87156a9947be39f08040f9
