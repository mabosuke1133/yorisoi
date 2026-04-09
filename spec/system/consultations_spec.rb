require 'rails_helper'

RSpec.describe "相談管理機能", type: :system do
  let(:admin) { create(:admin) } # 管理者ユーザー
  let(:user) { create(:user, name: "相談 太郎") }
  # 最初に「未対応」の相談を作っておく
  let!(:consultation) { create(:consultation, user: user, title: "困っています", status: :pending) }

  before do
    # 管理者ログイン画面へ（パスはご自身の環境に合わせて調整してください）
    visit new_admin_session_path
    fill_in 'メールアドレス', with: admin.email
    fill_in 'パスワード', with: admin.password
    click_button 'ログイン'
  end

  it "一覧から詳細に入り、対応開始、返信、完了までの一連の流れができること" do
    # 1. 一覧画面で相談を確認
    visit admin_consultations_path
    expect(page).to have_content "個別相談一覧"
    expect(page).to have_content "相談 太郎"
    expect(page).to have_content "未対応"

    # 2. タイトルリンクをクリックして詳細画面へ
    click_link "困っています"

    # 3. 詳細画面で「対応開始」を押す
    expect(page).to have_content "チャットはまだ利用できません"
    click_on "この相談の対応を開始する"

    # 4. 返信を投稿する
    expect(page).to have_content "対応中"
    # placeholder（相談者への返信を入力してください...）を利用して入力
    fill_in '相談者への返信を入力してください...', with: "運営です。お疲れ様です！"
    click_on "返信する"

    # 5. 画面に自分の返信が表示されたか確認
    expect(page).to have_content "運営です。お疲れ様です！"

    # 6. 相談を完了させる（確認ダイアログのOKを押す）
    # ※ data-confirm がある場合は、accept_confirm ブロックで囲むと自動でOKを押してくれます
    # accept_confirm do
      click_on "相談を完了する"
    # end

    # 7. 最終的なステータスを確認
    expect(page).to have_content "完了済み"
    expect(page).not_to have_button "返信する" # 完了後はフォームが消える仕様通り
  end
end