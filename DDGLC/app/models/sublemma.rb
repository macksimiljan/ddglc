class Sublemma < ApplicationRecord
  belongs_to :part_of_speech, optional: true
  belongs_to :language, optional: true
  belongs_to :lemma, optional: true
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  has_many :sublemma_comments
  has_many :usages

  paginates_per 10

  validates :label, presence: true
  validates :hierarchy, allow_blank: true, format: {with: /\A[IVX]+[.]?[A-Z]?[.]?[0-9]*\z/}

  NIL_ATTRS = %w[part_of_speech_id language_id hierarchy loaned_form lemma_id].freeze

  def comments_for(field)
    comments = sublemma_comments.where(field: field)
    comments ||= []
    comments
  end

  def nil_if_blank
    NIL_ATTRS.each{ |attr| self[attr] = nil if self[attr].blank? }
  end
end
