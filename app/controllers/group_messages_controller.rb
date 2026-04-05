class GroupMessagesController < ApplicationController
  # 💡 どちらかがログインしていればOKにする
  before_action :authenticate_any!

  def create
    @group = Group.find(params[:group_id])
    
    # 💡 修正ポイント1：判定用の変数を show と完全に一致させる
    approved_total = @group.users.count + 1 # オーナー + メンバー
    is_chat_available = approved_total >= 3
    
    # 💡 修正ポイント2：メンバー判定をシンプルにする
    is_member = user_signed_in? && (@group.owner == current_user || @group.users.include?(current_user))

    # 管理者、または「3人以上のチーム 且つ メンバー本人」なら投稿OK
    if admin_signed_in? || (is_chat_available && is_member)
      @message = @group.group_messages.new(message_params)
      
      if admin_signed_in?
        @message.admin_id = current_admin.id
        @message.user_id = nil
      else
        @message.user_id = current_user.id
      end

      if @message.save
        redirect_to group_path(@group), notice: "メッセージを送信しました"
      else
        redirect_to group_path(@group), alert: "メッセージを入力してください"
      end
    else
      # 💡 3人未満、あるいは部外者の場合はここへ
      redirect_to group_path(@group), alert: "メッセージを送信する権限がありません（3名以上の参加が必要です）"
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