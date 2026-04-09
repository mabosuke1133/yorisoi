require 'rails_helper'

RSpec.describe "Consultations", type: :request do
  let(:user) { create(:user) } # テスト用のユーザーを用意

  describe "GET /index" do
    context "ログインしている場合" do
      before do
        sign_in user # ここでログイン状態にする！
      end

      it "正常にレスポンスを返すこと（200 OK）" do
        get consultations_path
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトされること" do
        get consultations_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /create" do
    let(:user) { create(:user) }
    
    # 相談のパラメータ（フォームに入力する内容）を準備
    let(:consultation_params) { { consultation: { title: "テストタイトル", body: "テスト本文" } } }

    before do
      sign_in user
    end

    context "有効なパラメータの場合" do
      it "相談が新しく作成されること" do
        # 実行した結果、Consultationの数が「1増える」ことを期待する
        expect {
          post consultations_path, params: consultation_params
        }.to change(Consultation, :count).by(1)
      end

      it "作成後に詳細画面（または一覧）にリダイレクトされること" do
        post consultations_path, params: consultation_params
        # 成功した後のリダイレクト先を確認
        # ※もし一覧に飛ばす設定なら consultations_path に書き換えてください
        expect(response).to redirect_to(consultation_path(Consultation.last))
      end
    end

    context "無効なパラメータの場合" do
      it "相談が作成されないこと" do
        # タイトルを空にして送る
        invalid_params = { consultation: { title: "", body: "" } }
        expect {
          post consultations_path, params: invalid_params
        }.not_to change(Consultation, :count)
      end
    end
  end
end