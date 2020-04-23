class DownvotesController < ApplicationController
  def create
    link = Link.find(params[:link_id])
    link.downvote

    redirect_back(fallback_location:"/")
  end
end
