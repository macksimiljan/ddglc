class CreateSemanticFields < ActiveRecord::Migration[5.0]
  def change
    create_table :semantic_fields do |t|
      t.string :label, null: false
      t.string :url
      t.string :source, null: false

      t.timestamps
    end
  end
end
