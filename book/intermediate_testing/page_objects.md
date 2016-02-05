## Levels of Abstraction

Capybara gives us many useful commands and matchers for testing an
application from a user's point of view. However, these feature specs can easily
become hard to grok after adding just a few interactions. The best way to combat
this is to write feature specs at a **single level of abstraction**.

This test has many different levels of abstraction.

```ruby
# spec/features/user_marks_todo_complete_spec.rb
feature "User marks todo complete" do
  scenario "updates todo as completed" do
    sign_in # straight forward
    create_todo "Buy milk" # makes sense

    # huh? HTML list element ... text ... some kind of button?
    find(".todos li", text: "Buy milk").click_on "Mark complete"

    # hmm... styles ... looks like we want completed todos to look different?
    expect(page).to have_css(".todos li.completed", text: "Buy milk")
  end

  def create_todo(name)
    click_on "Add new todo"
    fill_in "Name", with: name
    click_on "Submit"
  end
end
```

The first two lines are about a user's interactions with the app. Then the next
lines drop down to a much lower level, messing around with CSS selectors and
text values. Readers of the test have to parse all these implementation details
just to understand _what_ is going on.

Ideally, the spec should read almost like pseudo-code:

```ruby
# spec/features/user_marks_todo_complete_spec.rb
feature "User marks todo complete" do
  scenario "updates todo as completed" do
    # sign_in
    # create_todo
    # mark todo complete
    # assert todo is completed
  end
end
```

The two most common ways to get there are **extract method** and **page
objects**.

### Extract Method

The **extract method** pattern is commonly used to hide implementation details
and to maintain a single level of abstraction in both source code and specs.

Consider the following spec:

```ruby
feature "User marks todo complete" do
  scenario "updates todo as completed" do
    sign_in
    create_todo "Buy milk"

    mark_complete "Buy milk"

    expect(page).to have_completed_todo "Buy milk"
  end

  def create_todo(name)
    click_on "Add new todo"
    fill_in "Name", with: name
    click_on "Submit"
  end

  def mark_complete(name)
    find(".todos li", text: name).click_on "Mark complete"
  end

  def have_completed_todo(name)
    have_css(".todos li.completed", text: name)
  end
end
```

Notice how obvious it is what happens in the scenario now. There is no more
context switching, no need to pause and decipher CSS selectors. The interactions
are front and center now. Details such as selectors or the exact text of that
link we need to click are largely irrelevant to readers of our spec and will
likely change often. If we really want to know what is entailed in marking a
todo as "complete", the definition is available just a few lines below.
Convenient yet out of the way.

Although this does make code reusable if we were to write another scenario, the
primary purpose of extracting these methods is not to reduce duplication.
Instead, it serves as a way to bundle lower-level steps and name them as
higher-level concepts. Communication and maintainability are the main goal here,
easier code-reuse is a useful side effect.

### Page objects

In a RESTful Rails application, the interactions on a page are usually based
around a single resource. Notice how all of the extracted methods in the example
above are about todos (creating, completing, expecting to be complete) and most
of them have `todo` in their name.

What if instead of having a bunch of helper methods that did things with todos,
we encapsulated that logic into some sort of object that manages todo
interactions on the page? This is the **page object** pattern.

Our feature spec (with a few more scenarios) might look like:

```ruby
scenario "create a new todo" do
  sign_in_as "person@example.com"
  todo = todo_on_page

  todo.create

  expect(todo).to be_visible
end

scenario "view only todos the user has created" do
  sign_in_as "other@example.com"
  todo = todo_on_page

  todo.create
  sign_in_as "me@example.com"

  expect(todo).not_to be_visible
end

scenario "complete my todos" do
  sign_in_as "person@example.com"
  todo = todo_on_page

  todo.create
  todo.mark_complete

  expect(todo).to be_complete
end

scenario "mark completed todo as incomplete" do
  sign_in_as "person@example.com"
  todo = todo_on_page

  todo.create
  todo.mark_complete
  todo.mark_incomplete

  expect(todo).not_to be_complete
end

def todo_on_page
  TodoOnPage.new("Buy eggs")
end
```

The todo is now front and center in all these tests. Notice that the tests now
only say _what_ to do. In fact, this test is no longer web-specific. It could be
for a mobile or desktop app for all we know. Low-level details, the _how_, are
encapsulated in the `TodoOnPage` object. Using an object instead of simple
helper methods allows us to build more complex interactions, extract state and
extract private methods. Notice that the helper methods all required the same
title parameter that is now instance state on the page object.

Let's take a look at what an implementation of `TodoOnPage` might look like.

```ruby
class TodoOnPage
  include Capybara::DSL

  attr_reader :title

  def initialize(title)
    @title = title
  end

  def create
    click_link "Create a new todo"
    fill_in "Title", with: title
    click_button "Create"
  end

  def mark_complete
    todo_element.click_link "Complete"
  end

  def mark_incomplete
    todo_element.click_link "Incomplete"
  end

  def visible?
    todo_list.has_css? "li", text: title
  end

  def complete?
    todo_list.has_css? "li.complete", text: title
  end

  private

  def todo_element
    find "li", text: title
  end

  def todo_list
    find "ol.todos"
  end
end
```

This takes advantage of RSpec's "magic" matchers, which turn predicate methods
such as `#visible?` and `#complete?` into matchers like `be_visible` and
`be_complete`. Also, we include `Capybara::DSL` to get all of the nice Capybara
helper methods.
