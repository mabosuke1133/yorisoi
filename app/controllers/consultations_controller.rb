class ConsultationsController < ApplicationController
  before_action :authenticate_user! # ログイン必須

  def index
    # 自分の相談だけを新しい順に取得
    @consultations = current_user.consultations.order(created_at: :desc)
    # 新規作成用の空のインスタンス
    @consultation = Consultation.new
  end

  def create
    @consultation = current_user.consultations.build(consultation_params)
    # ここでステータスの初期値をセットしておくと安心！
    @consultation.status ||= 'pending'
    
    if @consultation.save
      redirect_to consultation_path(@consultation), notice: "相談ルームを作成しました。メンターからの返信をお待ちください。"
    else
      @consultations = current_user.consultations.order(created_at: :desc)
      render :index
    end
  end

  def show
    @consultation = current_user.consultations.find(params[:id])
    @messages = @consultation.consultation_messages.order(:created_at)
    @message = ConsultationMessage.new
  end

  private

  def consultation_params
    params.fetch(:consultation, {}).permit(:title)
  end
end