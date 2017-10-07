class AddForeignKeysToLemma3 < ActiveRecord::Migration[5.0]
  # twice: one-to-many: user -- lemma
  def change
    add_reference :lemmas, :created_by, references: :users, index: true
    add_foreign_key :lemmas, :users, column: :created_by_id

    add_reference :lemmas, :updated_by, references: :users, index: true
    add_foreign_key :lemmas, :users, column: :updated_by_id
  end
end
