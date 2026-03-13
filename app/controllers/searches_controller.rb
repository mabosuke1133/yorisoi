class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    # 💡 ユーザーの選択（ユーザー or 投稿）を受け取る
    @range = params[:range]

    # 💡 コントローラーをシンプルに保つため、検索ロジックは各モデル(User/Post)の.looksメソッドに委譲
    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    else
      @posts = Post.looks(params[:search], params[:word])
    end
    # 💡 この後、search.html.erb側で@rangeを判定して結果を出し分ける
  end
end