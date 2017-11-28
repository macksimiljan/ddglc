class Language < ApplicationRecord

  def self.options_for_select
    order('LOWER(code)').map { |e| [e.code, e.id] }
  end
end
