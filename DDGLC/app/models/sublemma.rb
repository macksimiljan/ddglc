class Sublemma < ApplicationRecord
  belongs_to :part_of_speech, optional: true
  belongs_to :language, optional: true
  belongs_to :lemma, optional: true
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  paginates_per 15

  validates :label, presence: true
  validates :hierarchy, format: {with: /\A[I,V,X]+[.][A-Z][.][0-9]\z/}
end
