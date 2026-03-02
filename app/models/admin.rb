class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 仮想の属性（データベースには保存しないけどフォームで使う）
  attr_accessor :invitation_code

  # 保存する前に、招待コードが合っているかチェックする
  validates :invitation_code, inclusion: { in: ['yorisoi0000'], message: 'が正しくありません' }, on: :create
end
