class MessageRoom < ApplicationRecord
  belongs_to :issue
  belongs_to :admin
end
