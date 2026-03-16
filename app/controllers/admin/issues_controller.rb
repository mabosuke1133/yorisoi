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
          # 1. 誰をオーナーにするか決める（管理者/メンター）
          # ※ dummy@example.com がいない場合は、DBの最初のユーザーを予備で使います
          mentor = User.find_by(email: "dummy@example.com") || User.first

          # 2. ルームを作成（オーナーを管理者に設定）
          @group = Group.new(
            name: "個別相談ルーム",
            introduction: "こんにちは。メンターとの個別相談ルームとなります。現場での悩みや、誰にも言えない不安など、ここで自由にお話しください。",
            owner_id: @issue.user.id
          )
          @group.save!

          # 3. 相談者（ユーザー）をメンバーとして登録
          # これで「オーナー(管理者) + メンバー(ユーザー)」の2名体制のデータになります
          @group.permits.create!(
            user_id: @issue.user.id, 
            status: "approved"
          )

          # 4. 相談ステータスを更新
          @issue.update!(status: :in_progress)
        end

        # 成功したら詳細画面へ
        redirect_to group_path(@group), notice: "相談ルームを作成しました。対話を始めてください。"

      rescue => e
        redirect_to admin_issues_path, alert: "ルーム作成に失敗しました: #{e.message}"
      end
    else
      @issue.update(status: params[:status])
      redirect_to admin_issues_path, notice: "ステータスを更新しました。"
    end
  end
end