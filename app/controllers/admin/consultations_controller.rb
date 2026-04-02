class Admin::ConsultationsController < ApplicationController
  before_action :authenticate_admin! # 管理者ログイン必須

  def index
    # 全ユーザーの相談を、ステータス順（未対応が上）かつ新しい順に取得
    @consultations = Consultation.all.order(status: :asc, created_at: :desc)
  end

  def show
    @consultation = Consultation.find(params[:id])
    @messages = @consultation.consultation_messages.order(:created_at)
    @message = ConsultationMessage.new
  end

  def update
    @consultation = Consultation.find(params[:id])
    # 💡 「対応する」ボタンが押されたら status を processing (対応中) にし、担当者を自分にする
    if @consultation.update(status: :processing, mentor_id: current_admin.id)
      redirect_to admin_consultation_path(@consultation), notice: "相談の対応を開始しました。"
    else
      render :show
    end
  end
end