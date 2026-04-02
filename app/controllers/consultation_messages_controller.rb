class ConsultationMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @consultation = current_user.consultations.find(params[:consultation_id])
    @message = @consultation.consultation_messages.build(message_params)
    @message.user_id = current_user.id # 送信者はユーザー

    if @message.save
      redirect_to consultation_path(@consultation), notice: "メッセージを送信しました。"
    else
      redirect_to consultation_path(@consultation), alert: "メッセージの送信に失敗しました。"
    end
  end

  private

  def message_params
    params.require(:consultation_message).permit(:body)
  end
end