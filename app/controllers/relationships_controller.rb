class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: %i(create)
  before_action :load_relationship, only: :destroy

  def create
    current_user.follow @user
    flash[:success] = t "flash.follow.followed"
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow @user
    flash[:success] = t "flash.follow.destroy_followed"
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private
  def load_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t "flash.user.not_found"
    redirect_to root_path
  end

  def load_relationship
    @relationship = Relationship.find_by id: params[:id]
  end
end
