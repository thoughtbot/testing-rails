class Api::V1::LinksController < Api::BaseController
  def index
    links = Link.hottest_first
    render json: links
  end
end
