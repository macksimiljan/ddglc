class LemmaComment < ApplicationRecord
  belongs_to :lemma
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  def self.of(lemma_id, field)
    LemmaComment.where(lemma_id: lemma_id, field: field)
  end

end