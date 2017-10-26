class Usage < ApplicationRecord
  belongs_to :distinction_tier, optional: true
  belongs_to :sublemma, optional: true
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  has_and_belongs_to_many :usage_categories, (-> { uniq })

  has_many :usage_comments

  validates :hierarchy, allow_blank: true, format: {with: /\A[0-9]+[.]?[a-z]?[.]?[ivx]*[.]?[a-z]*\z/}

  paginates_per 10

  NIL_ATTRS = %w[coptic_specification meaning hierarchy distinction_tier_id sublemma_id criterion].freeze

  def comments_for(field)
    comments = usage_comments.where(field: field)
    comments ||= []
    comments
  end

  def nil_if_blank
    NIL_ATTRS.each{ |attr| self[attr] = nil if self[attr].blank? }
  end

end
