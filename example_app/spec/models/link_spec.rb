require "rails_helper"

RSpec.describe Link, "validations" do
  it { expect(subject).to validate_presence_of(:title) }
  it { expect(subject).to validate_presence_of(:url) }
end

RSpec.describe Link, "#upvote" do
  it "increments upvotes" do
    link = build(:link, upvotes: 1)

    link.upvote

    expect(link.upvotes).to eq 2
  end
end

RSpec.describe Link, "#downvote" do
  it "increments downvotes" do
    link = build(:link, downvotes: 1)

    link.downvote

    expect(link.downvotes).to eq 2
  end
end

RSpec.describe Link, "#score" do
  it "returns the upvotes minus the downvotes" do
    link = Link.new(upvotes: 2, downvotes: 1)

    expect(link.score).to eq 1
  end
end
