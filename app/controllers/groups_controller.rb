class GroupsController < ApplicationController
  # 🟢 管理者かユーザー、どちらかがログインしていれば閲覧を許可する
  before_action :authenticate_any!

  def index
    if admin_signed_in?
      @groups = Group.all
    elsif user_signed_in?
      # 💡 修正：一旦すべてのグループを取得する（Viewのif文でフィルタリングするため）
      @groups = Group.all.order(created_at: :desc)
      
      # 💡 「あなたが参加しているチーム」セクションを表示するために、
      # 自分が参加中（or オーナー）のグループだけを別途用意しておく
      my_ids = (current_user.owned_groups.pluck(:id) + current_user.participating_groups.pluck(:id)).uniq
      @my_all_groups = Group.where(id: my_ids)
    else
      @groups = Group.none
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    # 💡 強制的に「URLにフラグがある時だけ」相談モードにする（念のためのガード）
    @group.is_consultation = (params[:is_consultation] == "true" || params[:group][:is_consultation] == "true")
  
    if @group.save
      # 💡 修正ポイント：名前ではなく「is_consultation」フラグで判定！
      if @group.is_consultation?
        # 個別相談ルーム専用の処理（Issue作成など）
        @group.issues.create(title: "#{@group.name}の相談", completed: false)

        mentor = User.find_by(email: "dummy@example.com")
        if mentor
          @group.permits.create(user_id: mentor.id, status: "approved")
          @group.group_messages.create(
            body: "#{current_user.name}さん、こんにちは。担当のメンターです。相談内容を教えてくださいね。",
            user_id: mentor.id
          )
        end
        redirect_to group_path(@group), notice: "相談を開始しました"
      else
        # 普通のチームルーム
        redirect_to group_path(@group), notice: "チームルームを作成しました"
      end
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])

    # 1. 門番：入れるかどうかを判定
    can_view = admin_signed_in? || 
               (user_signed_in? && (
                 @group.owner == current_user || 
                 @group.users.include?(current_user) || 
                 current_user.following?(@group.owner)
               ))

    unless can_view
      redirect_to groups_path, alert: "このルームへのアクセス権限がありません。"
      return
    end

    # 2. 通過した人だけ、中身のデータを準備する
    if @group.is_consultation == true
      @issue = Issue.where(group_id: @group.id).order(created_at: :desc).first
    else
      @issue = nil
    end

    # --- 💡 ここが修正ポイント：3人判定のロジックを確実にする ---
    # オーナー(1) + 承認済みメンバー(users.count) の合計を出す
    @approved_total = @group.users.count + 1
    # 合計が3人以上ならチャット解禁
    @is_chat_available = @approved_total >= 3
    # ------------------------------------------------------

    @group_message = GroupMessage.new
  end

  def destroy
    @group = Group.find(params[:id])
    
    # 💡 作成者本人、または「管理者（Admin）」であれば削除を許可する
    if (user_signed_in? && @group.owner == current_user) || admin_signed_in?
      @group.destroy
      redirect_to groups_path, notice: "グループを削除しました"
    else
      redirect_to groups_path, alert: "削除する権限がありません"
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image, :is_consultation)
  end

  # 管理者(Admin)または一般ユーザー(User)のどちらかがログインしていれば通す門番
  def authenticate_any!
    if admin_signed_in?
      # 管理者ならOK
    elsif user_signed_in?
      # ユーザーならOK
    else
      # どちらでもなければログイン画面へ（デフォルトはユーザー用）
      authenticate_user!
    end
  end
end