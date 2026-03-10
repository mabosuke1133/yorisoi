class GroupsController < ApplicationController
  before_action :authenticate_user!

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
    @group.owner_id = current_user.id # 💡 作成者を自分にする
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
  # 💡 物理的に「作った人」以外は削除できないようにブロックする
  if @group.owner == current_user || current_user.admin?
    @group.destroy
    redirect_to groups_path, notice: "グループを削除しました"
  else
    # 万が一、他人が削除しようとしたら一覧へ追い返す
    redirect_to groups_path, alert: "作成者以外は削除できません"
  end
end

  private

  def group_params
    params.require(:group).permit(:name, :introduction)
  end
end