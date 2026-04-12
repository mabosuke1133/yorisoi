require 'rails_helper'

RSpec.describe "グループチャット機能", type: :system do
  let!(:owner) { create(:user, name: "オーナー") }
  let!(:user) { create(:user, name: "スタッフA") }
  let!(:other_user) { create(:user, name: "スタッフB") }
  let!(:admin) { create(:admin) }
  
  # グループ作成
  let!(:group) { create(:group, owner: owner, name: "ケア相談チーム", is_active: true) }

  describe "チャット利用制限のテスト" do
    before do
      # スタッフAでログイン
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    it "承認メンバーが3人未満（オーナー+1名）の場合、チャットフォームが表示されないこと" do
      create(:permit, user: user, group: group, status: "approved")
      visit group_path(group)
      
      expect(page).to have_content "現在チームを準備中です"
      expect(page).to have_content "あと 1名 の承認でチャットが開始されます"
      expect(page).not_to have_button "メッセージを送る"
    end

    it "承認メンバーが3人以上（オーナー+2名）になると、チャットフォームが表示されること" do
      create(:permit, user: user, group: group, status: "approved")
      create(:permit, user: other_user, group: group, status: "approved")
      
      visit group_path(group)
      
      expect(page).to have_content "今のきもちをチームに届ける"
      expect(page).to have_button "メッセージを送る"
    end
  end

  describe "メッセージ投稿テスト" do
    before do
      # 3人以上の条件を満たす
      create(:permit, user: user, group: group, status: "approved")
      create(:permit, user: other_user, group: group, status: "approved")
      
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      visit group_path(group)
    end

    it "正常にメッセージが投稿でき、自分の投稿が「あなた」と表示されること" do
      fill_in 'group_message[body]', with: '体調はどうですか？'
      click_button 'メッセージを送る'

      expect(page).to have_content "メッセージを送信しました"
      expect(page).to have_content "体調はどうですか？"
      expect(page).to have_content "あなた"
    end

    it "空のメッセージは送信できず、アラートが表示されること" do
      fill_in 'group_message[body]', with: ''
      click_button 'メッセージを送る'

      expect(page).to have_content "メッセージを入力してください"
    end
  end

  describe "管理者（メンター）のアクセス制限テスト" do
    before do
      # 一般ユーザー同士が話せる状態（3人以上）にしておく
      create(:permit, user: user, group: group, status: "approved")
      create(:permit, user: other_user, group: group, status: "approved")

      # 管理者でログイン
      visit new_admin_session_path
      fill_in 'admin[email]', with: admin.email
      fill_in 'admin[password]', with: admin.password
      click_button 'ログイン'
      visit group_path(group)
    end

    it "管理者はチームルームの内容を閲覧できるが、投稿フォームは表示されないこと" do
      # ページアクセスとグループ名の表示を確認
      expect(page).to have_content "ルーム"
      expect(page).to have_content group.name
      
      # 仕様：管理者は「見守り役」なので、投稿用のボタンや入力欄が出てこないことを確認
      expect(page).not_to have_button "メッセージを送る"
      expect(page).not_to have_field "group_message[body]"
    end
  end
end