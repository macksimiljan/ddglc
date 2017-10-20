class CreateSublemmaComments < ActiveRecord::Migration[5.0]
  def change
    create_table :sublemma_comments do |t|
      t.references :sublemma, foreign_key: true
      t.string :field
      t.text :content

      t.timestamps
    end

    add_reference :sublemma_comments, :created_by, references: :users, index: true
    add_foreign_key :sublemma_comments, :users, column: :created_by_id

    add_reference :sublemma_comments, :updated_by, references: :users, index: true
    add_foreign_key :sublemma_comments, :users, column: :updated_by_id

    add_index :sublemma_comments, :field

  end
end
