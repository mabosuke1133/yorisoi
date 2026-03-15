class IssuesController < ApplicationController
  before_action :authenticate_user!

  def create
    # すでに「未対応」や「対応中」の相談がある場合は、新しく作らせない（二重送信防止）
    existing_issue = current_user.issues.where(status: [:unstarted, :in_progress]).exists?
    
    if existing_issue
      redirect_to posts_path, alert: "すでに相談依頼を送信済みです。メンターからの連絡をお待ちください。"
    else
      @issue = current_user.issues.new(status: :unstarted)
      if @issue.save
        redirect_to posts_path, notice: "メンターへ相談依頼を送信しました。"
      else
        redirect_to posts_path, alert: "送信に失敗しました。"
      end
    end
  end

  def destroy
    @issue = current_user.issues.find(params[:id])
    if @issue.unstarted? # まだメンターが対応していなければ消せる
      @issue.destroy
      redirect_to posts_path, notice: "相談依頼を取り消しました。"
    else
      redirect_to posts_path, alert: "すでに対応が始まっているため、取り消しできません。"
    end
  end
end