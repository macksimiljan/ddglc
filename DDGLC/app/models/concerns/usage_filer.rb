module UsageFiler
  extend ActiveSupport::Concern

  included do
    include Filter


    filterrific(
      default_filter_params: { sorted_by: 'id' },
      available_filters: %i[
        search_for_meaning
        sorted_by
        with_any_created_by_ids
        with_any_usage_category_ids
        with_any_updated_by_ids
        with_sublemma_label
      ]
    )


    scope :sorted_by, (->(sort_options) do
      direction = sort_options =~ /desc$/ ? :desc : :asc
      case sort_options.to_s
        when /^created_at/
          order(created_at: direction, id: :asc)
        when /^updated_at/
          order(updated_at: direction, id: :asc)
        else
          order(id: :asc)
      end
    end)

    scope :search_for_meaning, (->(query) do
      return nil if query.blank?

      terms = split_query query
      where(
        terms.map{|term| 'usages.meaning LIKE ?'}.join(' AND '),
        *terms
      )
    end)

    scope :with_sublemma_label, (->(query) do
      return nil if query.blank?

      terms = split_query query
      where(terms.map{ |term| 'sublemmas.label LIKE ?' }.join(' AND '), *terms).joins(:sublemma)
    end)

    scope :with_any_created_by_ids, (lambda { |created_by_ids|
      where(created_by_id: [*created_by_ids])
    })

    scope :with_any_distinction_tier_ids, (lambda { |distinction_tier_ids|
      where(distinction_tier_id: [*distinction_tier_ids])
    })

    scope :with_any_usage_category_ids, (lambda { |usage_category_ids|
      joins(:usage_categories).where('usage_categories.id IN ?', [*usage_category_ids])
    })


    scope :with_any_updated_by_ids, (lambda { |updated_by_ids|
      where(updated_by_id: [*updated_by_ids])
    })
  end

  module ClassMethods
    def options_for_sorted_by
      [
          ['Creation date', 'created_at_desc'],
          ['Last update', 'updated_at_desc']
      ]
    end
  end


end