### Rendering Images Inline

In order to keep our link rendering logic DRY, I moved all of it into
`app/views/links/_link.html.erb`. This way, we can reuse that partial anywhere
we want to display a link, and it can correctly render with or without the image
tag.

The associated spec looks like this:

` spec/views/links/_link.html.erb_spec.rb@adc60fb1b9d83339

In this spec, we build a link with an image URL, then `render` our partial with
our link as a local variable. We then make a simple assertion that the image
appears in the rendered HTML.

When I initially implemented this partial, I had forgotten to also render the
image on the link's show page. Since some functionality I expected to see wasn't
implemented, I wrote a test to cover that case as well.

` spec/views/links/show.html.erb_spec.rb@adc60fb1b9d83339

This test is similar to the previous one, but this time we are rendering a view
as opposed to a partial view. First, instead of a local variable we need to
assign an instance variable. `assign(:link, link)` will assign the value of the
variable `link` to the instance variable `@link` in our rendered view.

Instead of specifying the view to render, this time we let RSpec work its
"magic". RSpec infers the view it should render based on the name of the file in
the `describe` block.
