class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
    if @micropost.save
      flash[:success] = t "flash.micropost.create_success"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy current_user.feed.newest, items: Settings.page_7
      render "pages/home", status: :unprocessable_entity
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "flash.micropost.delete_success"
    else
      flash[:danger] = t "flash.micropost.delete_failure"
    end
    redirect_to root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:success] = t "pages.micropost.invalid"
    redirect_to root_url
  end
end
