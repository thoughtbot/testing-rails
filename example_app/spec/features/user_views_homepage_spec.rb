require "rails_helper"

RSpec.feature "User views homepage" do
  scenario "they see existing links" do
    link = create(:link)

    visit root_path

    expect(page).to have_link link.title, href: link.url
  end

  scenario "the links are sorted hottest to coldest" do
    create(:link, title: "Coldest", upvotes: 3, downvotes: 3)
    create(:link, title: "Hottest", upvotes: 5, downvotes: 1)
    create(:link, title: "Lukewarm", upvotes: 2, downvotes: 1)

    visit root_path

    expect(page).to have_css "#links li:nth-child(1)", text: "Hottest"
    expect(page).to have_css "#links li:nth-child(2)", text: "Lukewarm"
    expect(page).to have_css "#links li:nth-child(3)", text: "Coldest"
  end
end
