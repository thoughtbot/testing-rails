require "rails_helper"

RSpec.feature "User upvotes a link" do
  scenario "they see an increased score" do
    link = create(:link)

    visit root_path

    within "#link_#{link.id}" do
      click_on "Upvote"
    end

    expect(page).to have_css "#link_#{link.id} [data-role=score]", text: "1"
  end
end
