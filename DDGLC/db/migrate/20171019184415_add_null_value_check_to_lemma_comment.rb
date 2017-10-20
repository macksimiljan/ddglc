class AddNullValueCheckToLemmaComment < ActiveRecord::Migration[5.0]
  def change
    change_column :lemma_comments, :content, :string, null: false
  end
end
