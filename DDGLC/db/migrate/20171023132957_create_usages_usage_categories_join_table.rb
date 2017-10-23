class CreateUsagesUsageCategoriesJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :usages, :usage_categories do |t|
      t.index :usage_id
      t.index :usage_category_id
    end
  end
end
