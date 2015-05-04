class UpvotesController < ApplicationController
  def create
    link = Link.find(params[:link_id])
    link.upvote

    redirect_to :back
  end
end
