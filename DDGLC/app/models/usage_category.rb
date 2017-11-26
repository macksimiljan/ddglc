class UsageCategory < ApplicationRecord
  has_and_belongs_to_many :usages, -> { uniq }

  validates :code, presence: true, uniqueness: { case_sensitive: false }


  def self.options_for_select
    order('LOWER(code)').map { |e| [e.code.titleize, e.id] }
  end
end