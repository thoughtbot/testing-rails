require "rails_helper"

RSpec.feature "User submits a link" do
  scenario "they see the page for the submitted link" do
    link_title = "This Testing Rails book is awesome!"
    link_url = "http://testingrailsbook.com"

    visit root_path
    click_on "Submit a new link"
    fill_in "link_title", with: link_title
    fill_in "link_url", with: link_url
    click_on "Submit!"

    expect(page).to have_link link_title, href: link_url
  end

  context "the form is invalid" do
    scenario "they see a useful error message" do
      link_title = "This Testing Rails book is awesome!"

      visit root_path
      click_on "Submit a new link"
      fill_in "link_title", with: link_title
      click_on "Submit!"

      expect(page).to have_content "Url can't be blank"
    end
  end
end
