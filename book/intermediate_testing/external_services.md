## External services

Rails apps commonly interact with external services and APIs. In general we try
to avoid testing these because we don't own that code and the network is
unreliable. This means that the test suite could fail if the external service or
the internet connection was down even if our code is fine. In addition, it's
just plain [*slow*](#slowtests). So how do we get around this? There are a few
approaches:

### Adapter pattern

It's generally a best practice to encapsulate external interactions in an
**adapter class**. Your tests can stub this adapter instead of making the network
request.

An adapter for Twitter might look like:

```ruby
class TwitterAdapter
  def self.tweet(message)
    new(ENV.fetch("TWITTER_API_KEY"), ENV.fetch("TWITTER_SECRET_TOKEN")).
      tweet(message)
  end

  def initialize(api_key, secret_token)
    @client = Twitter::REST::Client.new do |config|
      config.access_token = api_key
      config.access_token_secret = secret_token
    end
  end

  def tweet(message)
    @client.update(message)
  end
end
```

It might be used in a controller like:

```ruby
class LevelCompletionsController < ApplicationController
  def create
    # other things

    TwitterAdapter.tweet(I18n.t(".success"))
  end
end
```

By wrapping up the Twitter code in an adapter, not only have we made it easier
to test but we've also encapsulated our dependency on the twitter gem as well as
the configuration of the environment variables.

We can stub the adapter in specs:

```ruby
describe "complete level" do
  it "posts to twitter" do
    allow(TwitterAdapter).to receive(:tweet).and_return(true)

    # do some things

    expect(TwitterAdapter).to have_received(:tweet).with(I18n.t(".success"))
  end
end
```

*Note that when testing the `TwitterAdapter` itself, you shouldn't stub it as
stubbing the system under test is an anti-pattern.*


### Injecting an adapter

In integration tests though, we try to avoid stubbing so as to test the entire
system. Sometimes, it makes sense to inject a fake adapter for the purpose of
testing. For example:

```ruby
module FakeSMS
  Message = Struct.new(:to, :from, :body)

  class Client
    # this allows us to "read" messages later on
    def self.messages
      @messages ||= []
    end

    def send_message(to:, from:, body:)
      self.class.messages << Message.new(to, from, body)
    end
  end
end
```

We can then inject it into our adapter class when running specs.

```ruby
# spec/rails_helper.rb

SMSClient.client = FakeSMS::Client
```

This allows us to write feature specs that look like this:

```ruby
feature "signing in" do
  scenario "with two factors" do
    user = create(:user, password: "password", email: "user@example.com")

    visit root_path
    click_on "Sign In"

    fill_in :email, with: "user@example.com"
    fill_in :password, with: "password"
    click_on "Submit"

    last_message = FakeSMS.messages.last
    fill_in :code, with: last_message.body
    click_on "Submit"

    expect(page).to have_content("Sign out")
  end
end
```

This approach is explored in more detail in this blog post on [testing SMS
interactions](https://robots.thoughtbot.com/testing-sms-interactions).

### Spying on external libraries

This approach is similar to that described above. However, instead of stubbing
and spying on adapter classes, you do so on external libraries since you don't
own that code. This could be a third-party wrapper around an API (such as the
Twitter gem) or a networking library like HTTParty. So, for example, a test
might look like this, where `Twitter:Rest:Client` is an external dependency:

```ruby
describe "complete level" do
  it "posts to twitter" do
    twitter = spy(:twitter)
    allow(Twitter::Rest::Client).to receive(:new).and_return(twitter)

    # do some things

    expect(twitter).to have_received(:update).with(I18n.t(".success"))
  end
end
```

So when do you stub a library directly rather than the adapter? The library is
an implementation of the adapter and should be encapsulated by it. Any time you
need to exercise the adapter itself (such as in the adapter's unit tests) you
can stub the external library. If the adapter is simply a collaborator of the
SUT, then you should stub the adapter instead.

### Webmock

[Webmock](https://github.com/bblimke/webmock) is a gem that allows us to
intercept HTTP requests and returns a canned response. It also allows you to
assert that HTTP requests were made with certain parameters. This is just like
stubbing and mocking we've looked earlier, but instead of applying it to an
object, we apply it to a whole HTTP request.

Because we are now stubbing the HTTP request itself, we can test out adapters
and how they would respond to various responses such as server or validation
errors.

```ruby
describe QuoteOfTheDay, "#fetch" do
  it "fetches a quote via the API" do
    quote_text = "Victorious warriors win first and then go to war, while defeated warriors go to war first and then seek to win."

    stub_request(:get, "api.quotes.com/today").
      with({ author: "Sun Tzu", quote: quote_text }.to_json)

    quote = QuoteOfTheDay.fetch

    expect(quote.author).to eq "Sun Tzu"
    expect(quote.text).to eq quote_text
  end
end
```

### Blocking all requests

Webmock can be configured to block all external web requests. It will raise an
error telling you where that request was made from. This helps enforce a
"no external requests in specs" policy. To do so, add the following line to your
`rails_helper.rb` file:

```ruby
WebMock.disable_net_connect!(:allow_localhost => true)
```

*This is a best practice and should be enabled on most applications.*

### VCR

[VCR][vcr] is a gem that allows us to record an app's HTTP requests and then
replay them in future test runs. It saves the responses in a fixtures file and
then serves it up instead of a real response the next time you make a request.
This means you don't have to manually define the response payloads and allows
easy replication of the actual production API's responses. These fixtures can
get stale so it's generally a good idea to expire them every now and then.

[vcr]: (https://github.com/vcr/vcr)

### Fakes

**Fakes** are little applications that you can boot during your test that will
mimic a real service. These give you the ability return dynamic responses
because they actually run code. We commonly write these as Sinatra apps and then
use Webmock or [capybara-discoball][discoball] load them up in tests.  These
fakes are often packaged as gems and many popular services have open source test
fakes written by the community.

A fake for Stripe (payment processor) might look like:

```ruby
class FakeStripe < Sinatra::Base
  post "/v1/customers/:customer_id/subscriptions" do
    content_type :json
    customer_subscription.merge(
      id: params[:id],
      customer: params[:customer_id]
    ).to_json
  end

  def customer_subscription
    # default subscription params
  end
end
```

We can use capybara-discoball to boot the fake app in our tests:

```
# spec/rails_helper.rb

Capybara::Discoball.spin(FakeStripe) do |server|
  url = "http://#{server.host}:#{server.port}"
  Stripe.api_base = url
end
```

`Capybara::Discoball` boots up a local server at a url like `127.0.0.1:4567`. We
set the `api_base` attribute on the `Stripe` class to point to our local server
instead of the real production Stripe servers. Our app will make real HTTP
requests to the local server running our fake, exercising all of our
application's code including the HTTP request handling. This approach is the
closest to the real world we can get without hitting the real service.

Fakes are particularly convenient when dealing with complex interactions such as
payments.

These fakes can be re-used beyond the test environment in [both development and
staging][fakes-blog-post].

[discoball]: (https://github.com/thoughtbot/capybara_discoball)
[fakes-blog-post]: (https://robots.thoughtbot.com/faking-apis-in-development-and-staging)

### The best approach?

There is no single best approach to handling external services. At the unit
level, stubbing adapters or using Webmock is our approach of choice. At the
integration level, fakes are quite pleasant to work with although we'll still
use Webmock for one-off requests. I've found VCR to be rather brittle and more
difficult to work with. As the most automated of all the options, you trade
control for convenience.

With all these approaches, the external API can change out from under you
without your tests breaking because they are explicitly _not_ hitting the real
API. The only way to catch this is by running the app against the real API,
either via the test suite (slow and unreliable), in CI, or manually in a staging
environment.
