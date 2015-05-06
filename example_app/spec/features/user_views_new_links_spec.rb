require "rails_helper"

RSpec.feature "User views new links" do
  scenario "the links are sorted newest to oldest" do
    create(:link, title: "Oldest", created_at: 1.year.ago)
    create(:link, title: "Middle", created_at: 1.week.ago)
    create(:link, title: "Newest", created_at: 1.day.ago)

    visit root_path
    click_on "new"

    expect(page).to have_css "#links li:nth-child(1)", text: "Newest"
    expect(page).to have_css "#links li:nth-child(2)", text: "Middle"
    expect(page).to have_css "#links li:nth-child(3)", text: "Oldest"
  end
end
