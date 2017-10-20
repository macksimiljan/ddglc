class Lemma < ApplicationRecord
  has_and_belongs_to_many :semantic_fields
  belongs_to :part_of_speech, optional: true
  belongs_to :language, optional: true
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  has_many :sublemmas
  has_many :lemma_comments

  ARTICLES = {mSg: 'ὁ', mDu: 'τώ', mPl: 'οἱ',
              fSg: 'ἡ', fDu: 'τά', fPl: 'αἱ',
              nSg: 'τό', nDu: 'τώ', nPl: 'τά',
              mfSg: 'ὁ / ἡ'}.freeze

  paginates_per 15

  def comments_for(field)
    comments = lemma_comments.where(field: field)
    comments ||= []
    comments
  end


end
