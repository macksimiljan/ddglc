class PartOfSpeech < ApplicationRecord
  def self.options_for_select
    order('LOWER(label)').map { |e| [e.label.titleize, e.id] }
  end
end
