class UsageCategory < ApplicationRecord
  has_and_belongs_to_many :usages
end