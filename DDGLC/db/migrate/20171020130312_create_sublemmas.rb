class CreateSublemmas < ActiveRecord::Migration[5.0]
  def change
    create_table :sublemmas do |t|
      t.string :label, null: false
      t.references :part_of_speech, foreign_key: true
      t.references :language, foreign_key: true
      t.references :lemma, foreign_key: true
      t.string :hierarchy
      t.string :loaned_form
      t.boolean :activated, default: true

      t.timestamps
    end

    add_reference :sublemmas, :created_by, references: :users, index: true
    add_foreign_key :sublemmas, :users, column: :created_by_id

    add_reference :sublemmas, :updated_by, references: :users, index: true
    add_foreign_key :sublemmas, :users, column: :updated_by_id
  end
end
