class Assignment < ApplicationRecord
  belongs_to :bubble
  belongs_to :assignee, class_name: "User"

  validates :assignee, uniqueness: { scope: :bubble }
end
