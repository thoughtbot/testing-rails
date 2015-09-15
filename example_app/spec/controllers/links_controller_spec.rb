require "rails_helper"

RSpec.describe LinksController, "#create" do
  context "when the link is invalid" do
    it "re-renders the form" do
      invalid_link = double(save: false)
      allow(Link).to receive(:new).and_return(invalid_link)

      post :create, link: { attribute: "value" }

      expect(response).to render_template :new
    end
  end
end
