### Cleaning up test data

By default, RSpec wraps all database interactions in a **database transaction**.
This means that any records created are only accessible within the transaction
and any changes made to the database will be rolled back at the end of the
transaction. Using transactions allows each test to start from a clean
environment with a fresh database.

This pattern breaks down when dealing with JavaScript in feature specs. Real
browsers (headless or not) run in a separate thread from your Rails app and are
therefore _outside_ of the database transaction. Requests made from these
drivers will not have access to the data created within the specs.

We can disable transactions in our feature specs but now we need to clean up
manually. This is where [**Database Cleaner**][database cleaner] comes in.
Database Cleaner offers three different ways to handle cleanup:

1. Transactions
2. Deletion (via the SQL `DELETE` command)
3. Truncation (via the SQL `TRUNCATE` command)

Transactions are much faster but won't work with JavaScript drivers. The speed
of deletion and truncation depends on the table structure and how many tables
have been populated. Generally speaking, SQL `DELETE` is slower the more rows
there are in your table while `TRUNCATE` has more of a fixed cost.

[database cleaner]: https://github.com/DatabaseCleaner/database_cleaner

First, disable transactions in `rails_helper.rb`.

```ruby
RSpec.configure do |config|
  config.use_transactional_fixtures = false
end
```

Our default database cleaner config looks like this:

```ruby
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
```

We clean the database with deletion once before running the suite. Specs default
to cleaning up via a transaction with the exception of those that use a
JavaScript driver. This gets around the issues created by using a real browser
while still keeping the clean up fast for most specs.
