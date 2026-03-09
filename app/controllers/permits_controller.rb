class PermitsController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    @permit = current_user.permits.new(group_id: @group.id)
    # 💡 最初は必ず「pending（保留）」で保存される
    @permit.status = :pending
    
    if @permit.save
      redirect_to group_path(@group), notice: "参加申請を送りました。承認をお待ちください。"
    else
      redirect_to group_path(@group), alert: "申請に失敗しました。"
    end
  end

  def destroy
    # 💡 申請を取り消す場合
    @permit = current_user.permits.find(params[:id])
    @permit.destroy
    redirect_to groups_path, notice: "参加申請を取り消しました。"
  end

  def update
    @permit = Permit.find(params[:id])
    @group = @permit.group

    # 💡 権限チェック：グループのオーナー本人しか承認・拒否できないようにする
    if @group.owner == current_user
      if params[:status] == "approved"
        @permit.approved! # 👈 enumの魔法！ statusを1(approved)にして保存
        redirect_to group_path(@group), notice: "参加を承認しました"
      elsif params[:status] == "rejected"
        @permit.rejected! # 👈 enumの魔法！ statusを2(rejected)にして保存
        redirect_to group_path(@group), notice: "参加を拒否しました"
      end
    else
      redirect_to groups_path, alert: "権限がありません"
    end
  end
end