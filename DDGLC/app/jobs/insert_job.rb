module InsertJob

  def normalize_field(values, field_key, field_value, is_optional=true)
    return values if field_value.blank? && is_optional
    raise 'Obligatory field is empty' if field_value.blank? && !is_optional
    values[field_key] = field_value.squish
    values
  end

  def pos(values, field_value)
    field_value = field_value.nil? ? nil : field_value.squish
    return values if field_value.blank?
    return values if field_value == 'TBD' || field_value == 'TBA'
    pos = PartOfSpeech.find_by_label(field_value.downcase)
    raise "Cannot find POS" if pos.nil?
    values[:part_of_speech] = pos
    values
  end

  def language(values, field_value)
    return values if field_value.blank?

    field_value = field_value.nil? ? nil : field_value.squish
    lang = Language.find_by_code(field_value)
    raise "Cannot find language" if lang.nil?
    values[:language] = lang
    values
  end
end