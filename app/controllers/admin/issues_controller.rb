class Admin::IssuesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @issues = Issue.all.order(created_at: :desc)
  end

  def update
    @issue = Issue.find(params[:id])
    
    if params[:status] == 'in_progress'
      begin
        ActiveRecord::Base.transaction do
          mentor = User.find_by(email: "dummy@example.com") || User.first

          # 2. ルームを作成
          @group = Group.new(
            name: "個別相談ルーム",
            introduction: "メンターとの個別相談ルームとなります。現場での悩みや、誰にも言えない不安など、ここで自由にお話しください。",
            owner_id: @issue.user.id,
            issue_id: @issue.id  # 💡 ここを追加！これで「絆」が保存されます
          )
          @group.save!

          # 3. 相談者（ユーザー）をメンバーとして登録
          @group.permits.create!(
            user_id: @issue.user.id, 
            status: "approved"
          )

          # 4. 相談ステータスを更新
          @issue.update!(status: :in_progress)
        end

        redirect_to "/groups/#{@group.id}", notice: "相談ルームを作成しました。対話を始めてください。"

      rescue => e
        redirect_to admin_issues_path, alert: "ルーム作成に失敗しました: #{e.message}"
      end
    else
      @issue.update(status: params[:status])
      redirect_to admin_issues_path, notice: "ステータスを更新しました。"
    end
  end

  def complete
    @issue = Issue.find(params[:id])
    
    # 💡 修正：:published ではなく :completed に変更
    if @issue.update(status: :completed)
      redirect_to admin_issues_path, notice: "対応を完了しました。"
    else
      # もし詳細画面(show)がない場合は admin_issues_path にリダイレクトでもOK
      redirect_to admin_issues_path, alert: "更新に失敗しました。"
    end
  end
end