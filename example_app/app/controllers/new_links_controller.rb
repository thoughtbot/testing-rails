class NewLinksController < ApplicationController
  def index
    @links = Link.newest_first

    render "links/index"
  end
end
