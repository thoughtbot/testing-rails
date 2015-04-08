class LinksController < ApplicationController
  def index
  end

  def show
    @link = Link.find(params[:id])
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.create(link_params)
    redirect_to @link
  end

  private

  def link_params
    params.require(:link).permit(:title, :url)
  end
end
