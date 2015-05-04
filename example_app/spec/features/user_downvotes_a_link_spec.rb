require "rails_helper"

RSpec.feature "User downvotes a link" do
  scenario "they see a decreased score" do
    link = create(:link, upvotes: 4)

    visit root_path

    within "#link_#{link.id}" do
      click_on "Downvote"
    end

    expect(page).to have_css "#link_#{link.id} [data-role=score]", text: "3"
  end
end
