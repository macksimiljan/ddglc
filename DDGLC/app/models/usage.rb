class Usage < ApplicationRecord
  belongs_to :distinction_tier, optional: true
  belongs_to :sublemma, foreign_key: true
  has_and_belongs_to_many :usage_categories

  validates :hierarchy, allow_blank: true, format: {with: /\A[0-9]+[.]?[a-z]?[.]?[ivx]*\z/}

  def comments_for(field)
    # comments = sublemma_comments.where(field: field)
    comments ||= []
    comments
  end

end
