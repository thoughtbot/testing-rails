### Creating links

Next, we'll test creating a new link via our API:

` spec/requests/api/v1/links_spec.rb@8ca37400a:23,43

`attributes_for` is another FactoryGirl method, which gives you a hash of the
attributes defined in your factory. In this case, it would return:

```
{ title: "Testing Rails", url: "http://testingrailsbook.com" }
```

This time, we `POST` to `/api/v1/links`. `post` takes a second hash argument for
the data to be sent to the server. We assert on the response status. `201`
indicates that the request succeeded in creating a new record. We then check
that the last `Link` has the title we expect to ensure it is creating a record
using the data we submitted.

In the second test, we introduce a new FactoryGirl concept called traits. Traits
are specialized versions of factories. To declare them, you nest them under
a factory definition. This will give them all the attributes of the parent
factory, as well as any of the modifications specified in the trait. With the
new trait, our `Link` factory looks like this:

` spec/factories.rb@8ca37400a:2,9

The `:invalid` trait nulls out the `title` field so we can easily create invalid
records in a reusable manner.
