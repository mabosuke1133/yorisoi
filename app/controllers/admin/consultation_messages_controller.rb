class Admin::ConsultationMessagesController < ApplicationController
  before_action :authenticate_admin!

  def create
    @consultation = Consultation.find(params[:consultation_id])
    @message = @consultation.consultation_messages.build(message_params)
    @message.admin_id = current_admin.id # 送信者は管理者

    if @message.save
      redirect_to admin_consultation_path(@consultation), notice: "返信を送信しました。"
    else
      redirect_to admin_consultation_path(@consultation), alert: "返信の送信に失敗しました。"
    end
  end

  private

  def message_params
    params.require(:consultation_message).permit(:body)
  end
end