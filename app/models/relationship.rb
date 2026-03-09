class Relationship < ApplicationRecord
  # class_name: "User" を指定することで、follower_id が User を指すことを明示
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end