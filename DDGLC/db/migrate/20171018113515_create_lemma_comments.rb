class CreateLemmaComments < ActiveRecord::Migration[5.0]
  def change
    create_table :lemma_comments do |t|
      t.belongs_to :lemma, index: true
      t.string :field
      t.text :content
    end

    add_foreign_key :lemma_comments, :lemmas

    add_reference :lemma_comments, :created_by, references: :users, index: true
    add_foreign_key :lemma_comments, :users, column: :created_by_id

    add_reference :lemma_comments, :updated_by, references: :users, index: true
    add_foreign_key :lemma_comments, :users, column: :updated_by_id

    add_index :lemma_comments, :field
  end
end
