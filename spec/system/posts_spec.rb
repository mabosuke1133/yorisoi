require 'rails_helper'

RSpec.describe "広場機能", type: :system do
  let(:user) { create(:user) }

  before do
    # ログインページへ移動
    visit new_user_session_path
    # フォームに入力
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    # ログインボタンをクリック
    click_button 'ログイン'
  end

  it "ログインして広場に投稿できること" do
    visit posts_path
    
    # 1. リンクの名前を確認（もし index.html.erb で '新規投稿' ならそのままでOK）
    click_on '今の気持ちを投稿する' 

    # 2. ラベルに合わせて '内容' に修正
    fill_in 'タイトル', with: 'System Specのテスト'
    fill_in '内容', with: 'ブラウザ操作が自動で動いています！'
    
    # 3. ラジオボタンの選択（ラベルのテキストを指定）
    choose '独り言' 
    
    # 4. ボタンの文字に合わせて修正
    click_on 'みんなに届ける'

    # 5. 完了メッセージと内容の確認
    expect(page).to have_content '投稿しました！'
    expect(page).to have_content 'System Specのテスト'
  end
end