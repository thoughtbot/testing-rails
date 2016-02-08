## False Positives

Occasionally, you'll run into a case where a feature doesn't work while the test
for it is incorrectly passing. This usually manifests itself when the test is
written after the production code in question. The solution here is to always
follow Red, Green, Refactor. If you don't see your test fail before seeing it
turn green, you can't be certain that the change you are making is the thing
that actually got the test to pass, or if it is passing for some other reason.
By seeing it fail first, you know that once you get it to pass it is passing
because of the changes you made.

Sometimes, you need to figure out how to get your production code working before
writing your test. This may be because you aren't sure how the production
code is going to work and you just want to try some things out before you know
what you're going to test. When you do this and you go back to write your test,
be sure that you comment out the production code that causes the feature to
work. This way, you can write your test and see it fail. Then, when you comment
in the code to make it pass, you'll be certain that _that_ was the thing to make
the test pass, so your test is valid.
