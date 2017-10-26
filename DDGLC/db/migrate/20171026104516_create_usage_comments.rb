class CreateUsageComments < ActiveRecord::Migration[5.0]
  def change
    create_table :usage_comments do |t|
      t.references :usage, foreign_key: true
      t.string :field
      t.text :content, null: false

      t.timestamps
    end

    add_reference :usage_comments, :created_by, references: :users, index: true
    add_foreign_key :usage_comments, :users, column: :created_by_id

    add_reference :usage_comments, :updated_by, references: :users, index: true
    add_foreign_key :usage_comments, :users, column: :updated_by_id

    add_index :usage_comments, :field

  end
end
