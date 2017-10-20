class LemmaComment < ApplicationRecord
  belongs_to :lemma, dependent: :destroy
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  validates :content, presence: true, length: { in: 4..650 }
  validates :created_by, presence: true
  

end