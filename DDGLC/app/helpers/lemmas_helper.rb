module LemmasHelper
  def optional_field(field)
    return '-' if field.blank?
    field
  end
end