class MessagesController < ApplicationRecord
  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params)
    @message.user_id = current_user.id

    if @message.save
      redirect_to room_path(@room) # 送信後はルーム画面に戻る
    else
      redirect_to room_path(@room), alert: "メッセージを送信できませんでした。"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end