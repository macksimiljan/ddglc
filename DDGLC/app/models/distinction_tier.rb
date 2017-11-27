class DistinctionTier < ApplicationRecord

  def self.options_for_select
    all.map{|tier| [tier.label, tier.id]}
  end
end