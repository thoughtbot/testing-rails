class Score
  CONTROVERSIAL_THRESHOLD = 0.2

  attr_reader :upvotes, :downvotes

  def initialize(link)
    @upvotes = link.upvotes
    @downvotes = link.downvotes
  end

  def value
    upvotes - downvotes
  end

  def controversial?
    score_delta_percentage < CONTROVERSIAL_THRESHOLD
  end

  def ==(other)
    other.upvotes == upvotes && other.downvotes == downvotes
  end

  alias :eql? :==

  def hash
    [upvotes, downvotes].hash
  end

  private

  def score_delta_percentage
    score_delta.to_f / high_score
  end

  def high_score
    [upvotes, downvotes].max
  end

  def score_delta
    value.abs
  end
end
