class GroupsController < ApplicationController
  # 🟢 管理者かユーザー、どちらかがログインしていれば閲覧を許可する
  before_action :authenticate_any!

  def index
    @groups = Group.all

    # 💡 ログイン中なら、自分に関係するグループを準備
    if user_signed_in?
      @my_groups = current_user.owned_groups # 自分が作った
      @joining_groups = current_user.participating_groups # 承認されて参加中
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    # 管理者が作成した場合は、便宜上システム上のオーナーにするか、処理を分ける必要がある
    # ここでは一般ユーザーが作成することを想定
    @group.owner_id = current_user.id if user_signed_in?
    
    if @group.save
      redirect_to groups_path, notice: "グループを作成しました"
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])
  end

  def destroy
    @group = Group.find(params[:id])
    
    # 💡 作成者本人、または「管理者（Admin）」であれば削除を許可する
    if (user_signed_in? && @group.owner == current_user) || admin_signed_in?
      @group.destroy
      redirect_to groups_path, notice: "グループを削除しました"
    else
      redirect_to groups_path, alert: "削除する権限がありません"
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction)
  end

  # 管理者(Admin)または一般ユーザー(User)のどちらかがログインしていれば通す門番
  def authenticate_any!
    if admin_signed_in?
      # 管理者ならOK
    elsif user_signed_in?
      # ユーザーならOK
    else
      # どちらでもなければログイン画面へ（デフォルトはユーザー用）
      authenticate_user!
    end
  end
end