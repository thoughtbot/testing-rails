class LinkMailer < ApplicationMailer
  def new_link(link)
    @link = link
    mail(to: "moderators@example.com")
  end
end
