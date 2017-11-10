module LemmaFilter
  extend ActiveSupport::Concern

  included do
    filterrific(
      default_filter_params: { sorted_by: 'id' },
      available_filters: [
        :sorted_by,
        :search_for_meaning
      ]
    )

    scope :sorted_by, ->(sort_options) do
      direction = sort_options =~ /desc$/ ? :desc : :asc
      case sort_options.to_s
      when /^part_of_speech/
        order(part_of_speech_id: direction, id: :asc)
      when /^created_at/
        order(created_at: direction, id: :asc)
      when /^updated_at/
        order(updated_at: direction, id: :asc)
      else
        order(id: :asc)
      end
    end

    scope :search_for_meaning, ->(query) do
      return nil if query.blank?

      # split query into terms,
      # replace '*' with '%' for wildcard searches
      terms = query.downcase
                   .split(/\s+/)
                   .map{ |term| (term.tr('*', '%') + '%').gsub(/%+/, '%') }
      where(
        terms.map{ |term| '(LOWER(lemmas.meaning) LIKE ?' }
             .join(' AND '),
        terms
      )

    end

  end

  module ClassMethods
    def options_for_sorted_by
      [
        ['Part of speech (asc)', 'part_of_speech_asc'],
        ['Part of speech (desc)', 'part_of_speech_desc'],
        ['Creation date (asc)', 'created_at_asc'],
        ['Creation date (desc)', 'created_at_desc'],
        ['Update date (asc)', 'updated_at_asc'],
        ['Update date (desc)', 'updated_at_desc']
      ]
    end
  end
end