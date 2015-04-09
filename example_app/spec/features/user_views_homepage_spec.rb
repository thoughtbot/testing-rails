require "rails_helper"

RSpec.feature "User views homepage" do
  scenario "they see existing links" do
    link = create(:link)

    visit root_path

    expect(page).to have_link link.title, href: link.url
  end
end
