require 'rails_helper'

RSpec.describe Consultation, type: :model do
  describe '初期状態のテスト' do
    it "新しく作成した時、ステータスがpending（未対応）であること" do
      consultation = create(:consultation)
      expect(consultation.status).to eq "pending"
    end
  end

  describe 'バリデーションのテスト' do
    it "タイトルがない場合は無効であること" do
      consultation = build(:consultation, title: nil)
      expect(consultation).not_to be_valid
    end
    it "本文（body）がない場合は無効であること" do
      consultation = build(:consultation, body: nil)
      expect(consultation).not_to be_valid
    end
  end
end