class CreateUsages < ActiveRecord::Migration[5.0]
  def change
    create_table :usages do |t|
      t.string :coptic_specification
      t.string :meaning
      t.string :hierarchy
      t.references :distinction_tier, foreign_key: true
      t.references :sublemma, foreign_key: true
      t.string :criterion
      t.integer :corresponding_usages, array: true, default: []

      t.timestamps
    end

    add_reference :usages, :created_by, references: :users, index: true
    add_foreign_key :usages, :users, column: :created_by_id

    add_reference :usages, :updated_by, references: :users, index: true
    add_foreign_key :usages, :users, column: :updated_by_id

  end
end
