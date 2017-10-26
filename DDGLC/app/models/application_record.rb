class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def squish_values
    self.class.column_names.each do |column|
      next unless self[column].is_a? String
      self[column].squish!
    end
  end
end
