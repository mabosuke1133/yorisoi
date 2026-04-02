class ConsultationMessage < ApplicationRecord
  belongs_to :consultation
  # user_id か admin_id のどちらかが入るので optional: true にします
  belongs_to :user, optional: true
  belongs_to :admin, optional: true

  validates :body, presence: true
end