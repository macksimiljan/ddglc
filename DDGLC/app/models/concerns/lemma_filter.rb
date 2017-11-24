module LemmaFilter
  extend ActiveSupport::Concern

  included do
    filterrific(
      default_filter_params: { sorted_by: 'id' },
      available_filters: %i[
        search_for_label
        search_for_meaning
        search_for_source
        sorted_by
        with_any_created_by_ids
        with_any_part_of_speech_ids
        with_any_updated_by_ids
      ]
    )

    scope :sorted_by, (->(sort_options) do
      direction = sort_options =~ /desc$/ ? :desc : :asc
      case sort_options.to_s
      when /^part_of_speech/
        order(part_of_speech_id: direction, id: :asc)
      when /^created_at/
        order(created_at: direction, id: :asc)
      when /^updated_at/
        order(updated_at: direction, id: :asc)
      when /^count_sublemmas/
        left_joins(:sublemmas).group(:id).order('COUNT(sublemmas.id) DESC')
      else
        order(id: :asc)
      end
    end)

    scope :search_for_meaning, (->(query) do
      return nil if query.blank?

      terms = query.downcase
                   .split(/\s+/)
                   .map{ |term| ('%' + term.tr('*', '%') + '%').gsub(/%+/, '%')}
      where(
        terms.map { |term| 'LOWER(lemmas.meaning) LIKE ?' }
             .join(' AND '),
        *terms
      )
    end)

    scope :search_for_label, (->(query) do
      return nil if query.blank?

      terms = query.split(/\s+/)
                   .map{ |term| ('%' + term.tr('*', '%') + '%').gsub(/%+/, '%')}
      where(
        terms.map { |term| 'lemmas.label LIKE ?' }.join(' AND '),
        terms
      )
    end)

    scope :search_for_source, (->(query) do
      return nil if query.blank?

      terms = query.split(/\s+/)
                   .map{ |term| ('%' + term.tr('*', '%') + '%').gsub(/%+/, '%')}
      where(
        terms.map { |term| 'lemmas.source LIKE ?'}.join(' AND '),
        terms
      )
    end)

    scope :with_any_created_by_ids, (lambda { |created_by_ids|
      where(created_by_id: [*created_by_ids])
    })

    scope :with_any_updated_by_ids, (lambda { |updated_by_ids|
      where(updated_by_id: [*updated_by_ids])
    })

    scope :with_any_part_of_speech_ids, (lambda { |part_of_speech_ids|
      where(part_of_speech_id: [*part_of_speech_ids])
    })

  end

  module ClassMethods
    def options_for_sorted_by
      [
        ['Part of speech', 'part_of_speech_asc'],
        ['Creation date', 'created_at_desc'],
        ['Last update', 'updated_at_desc'],
        ['No. Sublemmas', 'count_sublemmas_desc'],
      ]
    end
  end
end