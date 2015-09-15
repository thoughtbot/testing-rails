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

  context "when the link is valid" do
    it "sends an email to the moderators" do
      valid_link = double(save: true)
      allow(Link).to receive(:new).and_return(valid_link)
      allow(LinkMailer).to receive(:new_link)

      post :create, link: { attribute: "value" }

      expect(LinkMailer).to have_received(:new_link).with(valid_link)
    end
  end
end
