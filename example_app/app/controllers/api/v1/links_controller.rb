class Api::V1::LinksController < Api::BaseController
  def index
    links = Link.hottest_first
    render json: links
  end

  def create
    link = Link.new(link_params)

    if link.save
      render json: link, status: :created
    else
      render json: { errors: link.errors.full_messages },
        status: :unprocessable_entity
    end
  end

  private

  def link_params
    params.require(:link).permit(:title, :url)
  end
end
