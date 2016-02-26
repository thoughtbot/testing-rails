## Testing Code You Don't Own

When writing tests, it can be easy to get carried away and start testing more
than is necessary. One common mistake is to write unit tests for functionality
provided by a third-party library. For example:

```ruby
class User < ActiveRecord::Base
end
```

```ruby
describe "#save" do
  it "saves the user" do
    user = User.new

    user.save

    expect(user).to eq User.find(user.id)
  end
end
```

This test is not testing any code you've written but instead is testing
`ActiveRecord::Base#save` provided by Rails. Rails should already have tests for
this functionality, so you don't need to test it again.

This may seem obvious, but we've seen this in the wild more than you'd expect.

A more subtle example would be when composing behavior from third-party
libraries. For example:

```ruby
require "twitter"

class PublishService
  def initialize
    @twitterClient = Twitter::REST::Client.new
  end

  def publish(message)
    @twitter_client.update(message)
  end
end
```

```ruby
describe "#publish" do
  it "publishes to twitter" do
    new_tweet_request = stub_request(:post, "api.twitter.com/tweets")
    service = PublishService.new

    service.publish("message")

    expect(new_tweet_request).to have_been_requested
  end
end
```

This unit test is too broad and tests that the twitter gem is correctly
implementing HTTP requests. You should expect that the gem's maintainers have
already tested that. Instead, you can test behavior up to the boundary of the
third-party code using **stub**.

```
describe "#publish" do
  it "publishes to twitter" do
    client = double(publish: nil)
    allow(Twitter::REST::Client).to receive(:new).and_return(client)
    service = PublishService.new

    service.publish("message")

    expect(client).to have_received(:publish).with("message")
  end
end
```

Methods provided by third-party libraries should already be tested by those
libraries. In fact, they probably test more thoroughly and with more edge cases
than anything you would write yourself. (Re)writing these tests adds overhead to
your test suite without providing any additional value so we encourage you not
to write them at all.
