class AddForeignKeysToLemma < ActiveRecord::Migration[5.0]
  # many-to-many: semantic field -- lemma
  create_table :semantic_fields_lemmas, id: false do |t|
    t.belongs_to :semantic_field, index: true
    t.belongs_to :lemma, index: true
  end

  # one-to-many: language -- lemma
  def change
    add_reference :lemmas, :language, foreign_key: true
  end
end
