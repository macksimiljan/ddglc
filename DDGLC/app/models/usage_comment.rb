class UsageComment < ApplicationRecord
  belongs_to :usage, dependent: :destroy
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  validates :content, presence: true, length: { in: 3..1650 }
  validates :created_by, presence: true
end