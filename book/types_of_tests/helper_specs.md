## Helper Specs

Helpers are generally one-off functions that don't really fit anywhere else.
They can be particularly easy to test due to their small scope and lack of
side-effects.

We will add some formatting to the display of a link's score. While a high score
means that a link is popular, a low score can have multiple meanings. Is it new?
Is it controversial and thus has a high number of both positive and negative
votes? Is it just boring?

To make some of the context more obvious, we will format the score as `5 (+7,
-2)` instead of just showing the net score.

<<[types_of_tests/helper_specs/formatting_the_score.md]
