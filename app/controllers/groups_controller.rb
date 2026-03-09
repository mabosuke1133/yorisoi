class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = Group.all
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