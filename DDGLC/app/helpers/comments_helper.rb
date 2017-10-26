module CommentsHelper
  def delete_comment_button(comment_creator, class_name, comment)
    return unless comment_creator == current_user

    case class_name
    when 'Lemma'
      link_to lemma_comment_path(comment), method: :delete, data: {confirm: 'Are you sure?'} do
        fa_icon('trash')
      end
    when 'Sublemma'
      link_to sublemma_comment_path(comment), method: :delete, data: {confirm: 'Are you sure?'} do
        fa_icon('trash')
      end
    when 'Usage'
      link_to usage_comment_path(comment), method: :delete, data: {confirm: 'Are you sure?'} do
        fa_icon('trash')
      end
    else
      # not defined
    end
  end
end