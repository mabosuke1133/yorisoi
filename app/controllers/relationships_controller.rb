class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  # フォローするとき
  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    redirect_back(fallback_location: root_path)
  end

  # フォロー外すとき
  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_back(fallback_location: root_path)
  end

  # フォロー一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  # フォロワー一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end