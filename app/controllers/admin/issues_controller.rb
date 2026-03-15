class Admin::IssuesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @issues = Issue.all.order(created_at: :desc)
  end

  def update
    @issue = Issue.find(params[:id])
    
    # 💡 確実に「対応を開始する」ボタンが押された時の処理を特定
    if params[:status] == 'in_progress'
      begin
        ActiveRecord::Base.transaction do
          # 1. グループを作成（ここが失敗するとエラーメッセージが出ます）
          @group = Group.new(
            name: "相談：#{@issue.user.name}さん",
            introduction: "#{@issue.user.name}さんとの個別相談ルームです。",
            # owner_id が User を想定している場合、便宜上 @issue.user を指定するか、
            # モデルのバリデーションに合わせて調整してください
            owner_id: @issue.user.id 
          )
          @group.save!

          # 2. ユーザーを参加させる（GroupUser や UserGroup などの中間テーブル名に合わせてください）
          # もし「group.users << user」が動かない場合は、中間テーブルを直接作成します
          # GroupUser.create!(group_id: @group.id, user_id: @issue.user.id)

          # 3. 相談ステータスを更新
          @issue.update!(status: :in_progress)
        end

        # 4. 🚀 成功したら、作成したグループの詳細画面へジャンプ！
        redirect_to group_path(@group), notice: "相談ルームを作成しました。対話を始めてください。"

      rescue => e
        # 何かエラー（バリデーション落ち等）があれば、一覧に戻してエラーを表示
        redirect_to admin_issues_path, alert: "ルーム作成に失敗しました: #{e.message}"
      end
    else
      # 完了（completed）にする時などの通常処理
      @issue.update(status: params[:status])
      redirect_to admin_issues_path, notice: "ステータスを更新しました。"
    end
  end
end