class Link < ActiveRecord::Base
  validates :title, presence: true
  validates :url, presence: true

  def upvote
    increment!(:upvotes)
  end

  def downvote
    increment!(:downvotes)
  end

  def score
    upvotes - downvotes
  end
end
