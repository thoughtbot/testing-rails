class LinksController < ApplicationController
  def index
    @links = Link.hottest_first
  end

  def show
    @link = Link.find(params[:id])
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.new(link_params)

    if @link.save
      LinkMailer.new_link(@link)
      redirect_to link_path(@link)
    else
      render :new
    end
  end

  private

  def link_params
    params.require(:link).permit(:title, :url)
  end
end
