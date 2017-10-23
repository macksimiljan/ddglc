class CreateDistinctionTiers < ActiveRecord::Migration[5.0]
  def change
    create_table :distinction_tiers do |t|
      t.string :label, null: false
      t.string :description

      t.timestamps
    end
  end
end
