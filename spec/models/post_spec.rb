require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }

    it "タイトル、本文、ユーザーがあれば有効であること" do
      post = build(:post, user: user)
      expect(post).to be_valid
    end

    it "タイトルがない場合は無効であること" do
      post = build(:post, title: nil)
      expect(post).not_to be_valid
    end

    it "本文がない場合は無効であること" do
      post = build(:post, body: nil)
      expect(post).not_to be_valid
    end
  end
end