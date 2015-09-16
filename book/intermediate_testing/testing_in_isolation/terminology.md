### Terminology

The testing community has a lot of overlapping nomenclature when it comes to the
techniques for testing things in isolation. For example many refer to fake
objects that stand in for collaborators (**doubles**) as **mock objects** or
**test stubs** (not to be confused with **mocking** and **stubbing**).

RSpec itself added to the confusion by providing `stub` and `mock` aliases for
`double` in older versions (not to be confused with **mocking** and
**stubbing**).

Forcing a real collaborator to return a canned response to certain messages
(**stubbing**) is sometimes referred to as a **partial double**.

Finally, RSpec provides a `spy` method which creates a **double** that will
respond to any method. Although often used when **spying**, these can be used
anywhere you'd normally use a standard double and any double can be used when
spying. They term **spy** can be a bit ambiguous as it can refer to both
objects created via the `spy` method and objects used for spying.
