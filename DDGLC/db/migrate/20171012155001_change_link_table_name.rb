class ChangeLinkTableName < ActiveRecord::Migration[5.0]
  def change
    rename_table :semantic_fields_lemmas, :lemmas_semantic_fields
  end
end

