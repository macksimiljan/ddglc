module InsertJob

  def add_comment(comments, field, content)
    return comments if content.blank?
    content.squish!
    if content =~ /^[A-Z][a-z][A-Z][a-z][:]?/
      user_code = content[0..3]
      content = content[5..-1].squish
      user = User.find_by_code(user_code)
    end
    comments << {field: field, content: content, created_by: user}
  end

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

    field_value.gsub! ' - ', ': '
    field_value.gsub! 'impersonal Verb', 'verb: impersonal'
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

  def sublemma_hierarchy(values, field_value)
    return values if field_value.blank?

    # these are not the same symbols although they seem to be
    field_value.gsub! 'Ι', 'I'
    field_value.gsub! 'II', 'II'

    values[:hierarchy] = field_value.squish.upcase
    values
  end

  def date(values, field_key, field_value)
    field_value = field_value.nil? ? nil : field_value.squish
    values[field_key] = Time.parse(field_value)
    values
  end

  def user(values, field_key, field_value)
    raise "User cannot be empty" if field_value.blank?
    field_value = 'Admin' if field_value.eql? 'SU'
    field_value = 'ViWa' if field_value.eql? 'Viwa'

    field_value = field_value.nil? ? nil : field_value.squish
    user = User.create_with(
        email: 'ddglc@uni-leipzig.de',
        role: 'guest',
        password: 'ddglc123',
        password_confirmation: 'ddglc123'
    ).find_or_create_by!(code: field_value)
    values[field_key] = user
    values
  end
end