FactoryGirl.define do
  factory :link do
    title "Testing Rails"
    url "http://testingrailsbook.com"

    trait :invalid do
      title nil
    end
  end
end
