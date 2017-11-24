module Filter
  extend ActiveSupport::Concern

  module ClassMethods
    def split_query(query)
      query.tr! '*', '%'
      query.gsub! '_', '\_'

      query.split(/\s+/)
           .map{ |term| (term + '%').gsub(/%+/, '%')}
    end
  end

end