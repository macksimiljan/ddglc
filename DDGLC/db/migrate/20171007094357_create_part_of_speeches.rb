class CreatePartOfSpeeches < ActiveRecord::Migration[5.0]
  def change
    create_table :part_of_speeches do |t|
      t.string :label
      t.string :code, null: false

      t.timestamps
    end
    add_index :part_of_speeches, :code, unique: true
  end
end
