class CreateLanguages < ActiveRecord::Migration[5.0]
  def change
    create_table :languages do |t|
      t.string :code
      t.string :label

      t.timestamps
    end
  end
end
