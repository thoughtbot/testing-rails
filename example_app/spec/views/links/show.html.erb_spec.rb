require "rails_helper"

RSpec.describe "links/show.html.erb" do
  context "if the url is an image" do
    it "renders the image inline" do
      link = build(:link, url: "http://example.com/image.jpg")
      assign(:link, link)

      render

      expect(rendered).to have_selector "img[src='#{link.url}']"
    end
  end
end
