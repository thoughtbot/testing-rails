class DownvotesController < ApplicationController
  def create
    link = Link.find(params[:link_id])
    link.downvote

    redirect_to :back
  end
end
