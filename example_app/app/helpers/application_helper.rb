module ApplicationHelper
  def formatted_score_for(link)
    "#{link.score} (+#{link.upvotes}, -#{link.downvotes})"
  end
end
