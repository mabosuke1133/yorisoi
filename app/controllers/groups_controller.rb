class GroupsController < ApplicationController
  # 🟢 管理者かユーザー、どちらかがログインしていれば閲覧を許可する
  before_action :authenticate_any!

  def index
    if admin_signed_in?
      # 管理者は管理のために全部見える
      @groups = Group.all
    elsif user_signed_in?
      # 💡 一般ユーザーは「自分に関係があるもの」だけに絞り込む
      # 自分がオーナーのグループ + 自分がメンバーとして承認されているグループ
      @groups = Group.where(id: current_user.owned_groups.pluck(:id) + current_user.participating_groups.pluck(:id))
    
      # ビューで「作成した」「参加中」と分けたいなら、以下も残してOK
      @my_groups = current_user.owned_groups
      @joining_groups = current_user.participating_groups
    else
      # ログインしていない場合は空（または公開グループのみ）
      @groups = Group.none
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id # 💡 オーナー設定は共通でOK
  
    if @group.save
      #  名前によって追加処理（メンター参加）を分ける
      if @group.name.include?("相談") || @group.name.include?("個別")
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
        #  普通のグループの場合
        redirect_to groups_path, notice: "グループを作成しました"
      end
    else
      #  バリデーションエラーなどで保存できなかった場合
      render :new
    end
  end

  def show
    @group = Group.find(params[:id])

    # 💡 修正：statusの制限を外し、そのユーザーの「一番新しい相談」を特定する
    # これにより、完了後（status: :completed）でも @issue が取得でき、Viewで判定が可能になります
    @issue = Issue.where(user_id: @group.owner_id)
                  .order(created_at: :desc)
                  .first

    # 💡 閲覧制限
    unless admin_signed_in? || @group.owner == current_user || @group.users.include?(current_user)
      redirect_to groups_path, alert: "このルームへのアクセス権限がありません。"
    end

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
    params.require(:group).permit(:name, :introduction)
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