class UsageCategory < ApplicationRecord
  has_and_belongs_to_many :usages, -> { uniq }

  validates :code, presence: true, uniqueness: { case_sensitive: false }
end