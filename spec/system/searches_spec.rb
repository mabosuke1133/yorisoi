require 'rails_helper'

RSpec.describe "投稿検索機能", type: :system do
  let!(:user) { create(:user) }
  # 検索にヒットさせる投稿
  let!(:target_post) { create(:post, title: "寄り添いのコツ", body: "現場での共感が大事です", user: user) }
  # 検索にヒットさせない投稿
  let!(:other_post) { create(:post, title: "今日のご飯", body: "美味しいカレーでした", user: user) }

  before do
    # 1. ログイン処理
    visit new_user_session_path
    # ※ラベル名（'メールアドレス'等）が実際のビューと異なる場合は、idやnameに変更してください
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
    
    # 2. 検索窓を設置した「みんなの広場」へ移動
    visit posts_path
  end

  describe "キーワード検索" do
    context "「寄り添い」で部分一致検索した場合" do
      it "正しい投稿が表示され、関係ない投稿は表示されないこと" do
        # UI側で設定したidを指定して入力
        fill_in 'search-input', with: '寄り添い'
        
        # 検索ボタン（id: search-button）をクリック
        click_button 'search-button'

        # 検索結果ページへ遷移することを確認
        expect(current_path).to eq search_path
        
        # ヒットすべき投稿があり、すべきでない投稿がないか
        expect(page).to have_content "寄り添いのコツ"
        expect(page).not_to have_content "今日のご飯"
      end
    end

    context "該当する投稿がない場合" do
      it "結果が見つからない旨のメッセージが表示されること" do
        fill_in 'search-input', with: '存在しないワード'
        click_button 'search-button'

        # 検索結果ページでのメッセージ確認
        # ※実際の検索結果画面（index.html.erb）の文言に合わせて調整してください
        expect(page).to have_content "検索結果が見つかりませんでした"
        expect(page).not_to have_content "寄り添いのコツ"
      end
    end
  end
end