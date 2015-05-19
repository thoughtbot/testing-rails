## View Specs

View specs allow you to test the logic in your views. While this logic should be
minimal, there are certainly times where you'll want to pull out the handy view
spec to test some critical functionality. A common antipattern in test suites is
testing too much in feature specs, which tend to be slow. This is especially a
problem when you have multiple tests covering similar functionality, with minor
variations.

In this section, we'll allow image links to be rendered inline. The main
functionality of displaying link posts was tested previously in a feature spec.
Aside from the already tested logic for creating a link, rendering a link post
as an inline image is mostly view logic. Instead of duplicating that
functionality in another feature spec, we'll write a view spec, which should
cover our use case and minimize test suite runtime.

<<[types_of_tests/view_specs/rendering_images_inline.md]
