require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:post_params) { { post: { title: "広場のテスト", body: "みんなで寄り添いましょう", emotion_level: 3, priority: :soliloquy } } }

  describe "GET /index" do
    context "ログインしている場合" do
      before { sign_in user }
      it "正常にレスポンスを返すこと" do
        get posts_path
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトされること" do
        get posts_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /create" do
    before { sign_in user }
    
    context "有効なパラメータの場合" do
      it "新しい投稿が作成されること" do
        expect {
          post posts_path, params: post_params
        }.to change(Post, :count).by(1)
      end
    end
  end
end
