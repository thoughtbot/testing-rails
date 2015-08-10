module ApplicationHelper
  def formatted_score_for(score)
    "#{score.value} (+#{score.upvotes}, -#{score.downvotes})"
  end
end
