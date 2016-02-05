### Testing Side Effects

So far, we've seen how to isolate ourselves from input from our collaborators.
But what about methods with side-effects whose only behavior is to send a
message to a collaborator? How do we test side-effects without having to test
the whole subsystem?

A common side-effect in a Rails application is sending email. Because we are
trying to test the controller in isolation here, we don't want to also have to
test the mailer or the filesystem in this spec.  Instead, we'd like to just test
that we told the mailer to send the email at the appropriate time and trust that
it will do its job correctly like proper object-oriented citizens.

RSpec provides two ways of "listening" for and expecting on  messages sent to
collaborators. These are **mocking** and **spying**.

### Mocking

When **mocking** an interaction with a collaborator we set up an expectation
that it will receive a given message and then exercise the system to see if that
does indeed happen. Let's return to our example of sending emails to moderators:

` spec/controllers/links_controller_spec.rb@b6755ba1b764d1d1

### Spying

Mocking can be a little weird because the expectation happens in the middle of
the test, contrary to the [**four-phase test**](#fourphasetest) pattern
discussed in an earlier section. **Spying** on the other hand does follow that
approach.

` spec/controllers/links_controller_spec.rb@db8110e40a4cc40a

Note that you can only spy on methods that have been stubbed or on test doubles
(often referred to as **spies** in this context because they are often passed
into an object just to record what messages are sent to it). If you try to spy
on an unstubbed method, you will get a warning that looks like:

> `<LinkMailer (class)>` expected to have received new_link, but that object is
> not a spy or method has not been stubbed.
