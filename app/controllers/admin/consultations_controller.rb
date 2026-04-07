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
    
    # 送られてきた status パラメータを取得（デフォルトは今の値を維持）
    new_status = params.dig(:consultation, :status) || @consultation.status

    # ステータス更新と担当者(mentor_id)の設定
    if @consultation.update(status: new_status, mentor_id: current_admin.id)
      
      # 💡 完了(completed)か、対応中(processing)かでメッセージを出し分ける
      case @consultation.status
      when 'completed'
        flash[:notice] = "相談を完了（解決済み）にしました。お疲れ様でした！"
      when 'processing'
        flash[:notice] = "相談の対応を開始しました。"
      else
        flash[:notice] = "ステータスを更新しました。"
      end
      
      redirect_to admin_consultation_path(@consultation)
    else
      @messages = @consultation.consultation_messages.order(:created_at)
      @message = ConsultationMessage.new
      render :show
    end
  end
end