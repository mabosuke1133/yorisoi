require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    it "名前とメールアドレスがあれば有効であること" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "名前が空だと無効であること" do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
    end
  end
end