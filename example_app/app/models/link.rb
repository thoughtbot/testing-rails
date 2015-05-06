class Link < ActiveRecord::Base
  validates :title, presence: true
  validates :url, presence: true

  def self.hottest_first
    order("upvotes - downvotes DESC")
  end

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
