require "rails_helper"

RSpec.describe Link, "validations" do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:url) }
end

RSpec.describe Link, ".hottest_first" do
  it "returns the links: hottest to coldest" do
    coldest_link = create(:link, upvotes: 3, downvotes: 3)
    hottest_link = create(:link, upvotes: 5, downvotes: 1)
    lukewarm_link = create(:link, upvotes: 2, downvotes: 1)

    expect(Link.hottest_first).to eq [hottest_link, lukewarm_link, coldest_link]
  end
end

RSpec.describe Link, ".newest_first" do
  it "returns the links: newest to oldest" do
    oldest_link = create(:link, created_at: 1.year.ago)
    middle_link = create(:link, created_at: 1.week.ago)
    newest_link = create(:link, created_at: 1.day.ago)

    expect(Link.newest_first).to eq [newest_link, middle_link, oldest_link]
  end
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

    expect(link.score).to eq Score.new(link)
  end
end

RSpec.describe Link, "#image?" do
  %w(.jpg .gif .png).each do |extension|
    it "returns true if the URL ends in #{extension}" do
      link = Link.new(url: "http://example.com/a#{extension}")

      expect(link.image?).to be_truthy
    end
  end

  it "returns false if the URL does not have an image extension" do
    link = Link.new(url: "http://not-an-image")

    expect(link.image?).to be_falsey
  end
end
