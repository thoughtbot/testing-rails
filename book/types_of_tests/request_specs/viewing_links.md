### Viewing links

The first endpoint we'll create is for an index of all existing links, from
hottest to coldest. We'll namespace everything under `/api/v1`.

` spec/requests/api/v1/links_spec.rb@f39adb6ff

We name our request spec files after the paths they test. In this case requests
to `/api/v1/links` will be tested in `spec/requests/api/v1/links_spec.rb`.

After setting up our data, we make a `GET` request with the built-in `get` method. We
then assert on the number of records returned in the JSON payload. Since all of
our requests will be JSON, and we are likely to be parsing each of them, I've
extracted a method `json_body` that parses the `response` object that is
provided by `rack-test`.

` spec/support/api_helpers.rb@f39adb6ff

I pulled the method out to its own file in `spec/support`, and include it
automatically in all request specs.

We could have tested the entire body of the response, but that would have been
cumbersome to write. Asserting upon the length of the response and the structure
of the first JSON object should be enough to have reasonable confidence that
this is working properly.
