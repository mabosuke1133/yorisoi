class RoomsController < ApplicationController
  before_action :authenticate_user! 

  def index
    @rooms = Room.all.order(created_at: :desc)
  end

  def new
    @post = Post.find(params[:post_id]) if params[:post_id] # どの投稿から相談部屋を作るか紐付けたい場合
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.user_id = current_user.id # 作成者を記録
    
    if @room.save
      # 💡 重要：作成者を最初の参加者としてEntryに登録する
      Entry.create(user_id: current_user.id, room_id: @room.id)
      redirect_to room_path(@room), notice: "相談ルームを作成しました。あと2人参加するとトークが開始されます。"
    else
      render :new
    end
  end

  def show
    @room = Room.find(params[:id])
    @entries = @room.entries # 参加者リスト
  end

  def join
    @room = Room.find(params[:id])
  
    # すでに参加していないか、かつ3人未満かチェック
    if !@room.users.include?(current_user)
      Entry.create(user_id: current_user.id, room_id: @room.id)
      redirect_to room_path(@room), notice: "ルームに参加しました！"
    else
      redirect_to rooms_path, alert: "参加できないか、すでに満員です。"
    end
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end
end