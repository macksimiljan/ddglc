module LemmasHelper
  def optional_field(field)
    return '-' if field.blank?
    field
  end

  def comment_button(target, label='')
    content_tag :button, class: 'btn btn-default btn-add-comment', type: 'button', 'data-toggle': 'collapse', 'data-target':target do
      fa_icon('commenting-o') + label
    end
  end
end