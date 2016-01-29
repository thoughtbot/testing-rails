require "rails_helper"

RSpec.describe LinkMailer, "#new_link" do
  it "delivers a new link notification email" do
    link = build(:link)

    email = LinkMailer.new_link(link)

    expect(email).to deliver_to(LinkMailer::MODERATOR_EMAILS)
    expect(email).to deliver_from("noreply@reddat.com")
    expect(email).to have_subject("New link submitted")
    expect(email).to have_body_text("A new link has been posted")
  end
end
