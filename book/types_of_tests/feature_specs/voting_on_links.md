### Voting on links

One of the most important parts of Reddit is being able to vote for posts. Let's
implement a basic version of this functionality in our app, where you can upvote
and downvote links.

Here's a basic test for upvoting links:

` spec/features/user_upvotes_a_link_spec.rb@d4001c148:3,15

There are a couple new things in this test. First is the `within` block.
`within` takes a selector and looks for a matching element on the page. It then
limits the scope of everything within the block to elements inside the specified
element. In this case, our page has a potential to have multiple links or other
instances of the word "Upvote". We scope our finder to only look for that text
within the list element for our link. We use the CSS id `#link_#{link.id}` which
is given by `content_tag_for`.

The second new method is `has_css`, which asserts that a given selector is on
the page. With the `text` option, it ensures that the provided text is found
within the given selector. The selector I use includes a data attribute:
`[data-role=score]`. We'll frequently use `data-role`s to decouple our test
logic from our presentation logic. This way, we can change class names and tags
without breaking our tests!
