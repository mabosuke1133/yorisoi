class GroupMessagesController < ApplicationController
  # 💡 どちらかがログインしていればOKにする
  before_action :authenticate_any!

  def create
    @group = Group.find(params[:group_id])
    
    # 管理者、または「承認済みメンバー or オーナー」なら投稿OK
    if admin_signed_in? || (@group.owner == current_user || @group.approved_users.include?(current_user))
      @message = @group.group_messages.new(message_params)
      
      if admin_signed_in?
        @message.admin_id = current_admin.id
        @message.user_id = nil # DBの掟回避のため明示的にnilにする
      else
        @message.user_id = current_user.id
      end

      if @message.save
        redirect_to group_path(@group), notice: "メッセージを送信しました"
      else
        redirect_to group_path(@group), alert: "メッセージを入力してください"
      end
    else
      redirect_to group_path(@group), alert: "権限がありません"
    end
  end

  private

  def message_params
    params.require(:group_message).permit(:body,:admin_id)
  end

  # 💡 どちらかがログインしていれば通す独自メソッド
  def authenticate_any!
    unless admin_signed_in? || user_signed_in?
      redirect_to root_path, alert: "ログインが必要です"
    end
  end
end