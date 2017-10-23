class CreateUsageCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :usage_categories do |t|
      t.string :code, null: false
      t.string :label

      t.timestamps
    end
  end
end
