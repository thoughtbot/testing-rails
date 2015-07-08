require "rails_helper"

RSpec.describe ApplicationHelper, "#formatted_score_for" do
  it "displays the net score along with the raw votes" do
    link = Link.new(upvotes: 7, downvotes: 2)
    formatted_score = helper.formatted_score_for(link)

    expect(formatted_score).to eq "5 (+7, -2)"
  end
end
