## Stubbing the System Under Test

As we've learned, [stubbing](#stubbing) allows us to isolate code we are testing
from other complex behavior. Sometimes, we are tempted to stub a method inside
the class we are testing. If a behavior is so complicated that we feel compelled
to stub it out in a test, that behavior is its own concern and should be
encapsulated in its own class.

Imagine we are interacting with a payment service that allows us to create and
refund charges to a credit card. Interacting with the service is similar for
each of these requests, so we implement a method `#create_transaction` that we
can reuse when creating and refunding charges:

```ruby
class CreditCard
  def initialize(id)
    @id = id
  end

  def create_charge(amount)
    create_transaction("/cards/#{@id}/charges", amount: amount)
  end

  def refund_charge(transaction_id)
    create_transaction("/cards/#{@id}/charges/#{transaction_id}/refund")
  end

  private

  def create_transaction(path, data = {})
    response = Net::HTTP.start("payments.example.com") do |http|
      post = Net::HTTP::Post.new(path)
      post.body = data.to_json
      http.request(post)
    end

    data = JSON.parse(response.body)
    Response.new(transaction_id: data["transaction_id"])
  end
end
```

`#create_transaction` makes an HTTP request to our payment gateway's endpoint,
parses the response data, and returns a new response object with the
`transaction_id` from the returned data. This is a relatively complicated
method, and we've learned before that external web requests can be unreliable
and slow, so we decide to stub this out in our tests for `#create_charge`
and `#refund_charge`.

An initial test for `#create_charge` might look like this:

```ruby
describe CreditCard, "#create_charge" do
  it "returns transaction IDs on success" do
    credit_card = CreditCard.new("4111")
    expected = double("expected")
    allow(credit_card).to receive(:create_transaction)
      .with("/cards/4111/charges", amount: 100)
      .and_return(expected)

    result = credit_card.create_charge(100)

    expect(result).to eq(expected)
  end
end
```

This test will work, but it carries some warning signs about how we've factored
our code. The first is we're stubbing a private method. [As we've
learned](#private-methods), tests shouldn't even be aware of private methods. If
you're paying attention, you'll also notice that we've stubbed the system under
test.

This stub breaks up our `CreditCard` class in an ad hoc manner. We've defined
behavior in our `CreditCard` class definition that we are currently trying to
test, and now we've introduced new behavior with our stub. Instead of splitting
this behavior just in our test, we should separate concerns deliberately in our
production code.

If we reexamine our code, we'll realize that our `CreditCard` class does in fact
have multiple concerns. One, is acting as our credit card, which can be charged
and refunded. The second, alluded to by our need to stub it, is formatting and
requesting data from our payment gateway. By extracting this behavior to a
`GatewayClient` class, we can create a clear distinction between our two
responsibilities, make each easier to test, and make our `GatewayClient`
functionality easier to reuse.

Let's extract the class and inject it into our `CreditCard` instance as a
dependency. First, the refactored test:

```ruby
describe CreditCard, "#create_charge" do
  it "returns transaction IDs on success" do
    expected = double("expected")
    gateway_client = double("gateway_client")
    allow(gateway_client).to receive(:post)
      .with("/cards/4111/charges", amount: 100)
      .and_return(expected)
    credit_card = CreditCard.new(gateway_client, "4111")

    result = credit_card.create_charge(100)

    expect(result).to eq(expected)
  end
end
```

Now, we are no longer stubbing the SUT. Instead, we've injected a double
that responds to a method `post` and returns our canned response. Now, we need
to refactor our code to match our expectations.

```ruby
class CreditCard
  def initialize(client, id)
    @id = id
    @client = client
  end

  def create_charge(amount)
    @client.post("/cards/#{@id}/charges", amount: amount)
  end

  def refund_charge(transaction_id)
    @client.post("/cards/#{@id}/charges/#{transaction_id}/refund")
  end
end

class GatewayClient
  def post(path, data = {})
    response = Net::HTTP.start("payments.example.com") do |http|
      post = Net::HTTP::Post.new(path)
      post.body = data.to_json
      http.request(post)
    end

    data = JSON.parse(response.body)
    Response.new(transaction_id: data["transaction_id"])
  end
end
```

Whenever you are tempted to stub the SUT, take a moment to think about why you
didn't want to set up the required state. If you could easily set up the state
with a factory or helper, prefer that and remove the stub. If the method you are
stubbing has complicated behavior which is difficult to retest, use that as a
cue to extract a new class, and stub the new dependency.
