## Request Specs

Request specs are integration tests that allow you to send a request and make
assertions on its response. As end-to-end tests, they go through the entire
Rails stack from route to response. Unlike feature specs, request specs do not
work with Capybara. Instead of interacting with the page like you would with
Capybara, you can only make basic assertions against the response, such as
testing the status code, redirection, or that text appeared in the response
body.

Request specs should be used to test API design, as you want to be confident
that the URLs in your API will not change. However, request specs can be used
for any request, not just APIs.

In this chapter, we'll add a basic API to our app to show how you might test one
with request specs.

<<[types_of_tests/request_specs/viewing_links.md]

<<[types_of_tests/request_specs/creating_links.md]
