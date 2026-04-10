require 'rails_helper'

RSpec.describe "ユーザー相談機能", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:admin) }

  describe "ログイン後の操作" do
    before do
      visit new_user_session_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password # ラベル名に合わせて password か パスワード に変更
      click_button 'ログイン'
    end

    it "相談一覧画面から新しく投稿できること" do
      visit consultations_path # 1. 画面に行く
  
      fill_in 'consultation[title]', with: 'キャリアの相談' 
      fill_in 'consultation[body]', with: '今後の歩み方について' # 2. タイトルと本文を書く（追加！）

      # 3. 申請ボタンを押す（確認ダイアログが出るので、OKを押す操作）
      page.accept_confirm do
        click_on '相談を申請する'
      end

      expect(page).to have_content '相談ルームを作成しました'
    end

    it "他人の相談詳細画面にはアクセスできない（404エラーになる）こと" do
      other_consultation = create(:consultation, user: other_user)
      
      # ActiveRecord::RecordNotFound が発生することを期待する
      # ※コントローラで current_user.consultations.find(params[:id]) としているため
      expect {
        visit consultation_path(other_consultation)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "未ログイン時の制限" do
    it "ログインせずに一覧画面へ行こうとするとログイン画面へ戻されること" do
      visit consultations_path
      expect(current_path).to eq new_user_session_path
    end

    it "ログインせずに管理画面(Admin)へアクセスできないこと" do
      visit admin_consultations_path
      expect(current_path).to eq new_admin_session_path
    end
  end
end