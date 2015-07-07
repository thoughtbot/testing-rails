require "rails_helper"

RSpec.describe LinksController, "#create" do
  context "when the link is invalid" do
    it "re-renders the form" do
      post :create, link: attributes_for(:link, :invalid)

      expect(response).to render_template :new
    end
  end
end
