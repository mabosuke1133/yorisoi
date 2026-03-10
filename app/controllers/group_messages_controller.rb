class GroupMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    
    # 💡 認可チェック！「承認済みメンバー」か「オーナー」しか投稿させない
    if @group.owner == current_user || @group.approved_users.include?(current_user)
      @message = @group.group_messages.new(message_params)
      @message.user_id = current_user.id
      if @message.save
        redirect_to group_path(@group), notice: "メッセージを投稿しました"
      else
        redirect_to group_path(@group), alert: "メッセージを入力してください"
      end
    else
      redirect_to group_path(@group), alert: "参加メンバーのみ投稿できます"
    end
  end

  private

  def message_params
    params.require(:group_message).permit(:body)
  end
end