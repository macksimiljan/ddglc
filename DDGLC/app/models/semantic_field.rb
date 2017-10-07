class SemanticField < ApplicationRecord
  has_and_belongs_to_many :lemmas
end
