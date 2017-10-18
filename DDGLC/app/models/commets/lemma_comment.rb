class LemmaComment < ApplicationRecord
  belongs_to :lemma
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

end