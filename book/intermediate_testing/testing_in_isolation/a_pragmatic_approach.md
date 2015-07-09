### A pragmatic approach

Sometimes you need to test a component that is really tightly coupled with
another. When this is framework code it is often better just to back up a bit
and test the two components together. For example models that inherit from
`ActiveRecord::Base` are coupled to ActiveRecord's database code. Trying to
isolate the model from the database can get really painful and there's nothing
you can do about it because you don't own the ActiveRecord code.
