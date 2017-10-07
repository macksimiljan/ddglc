class AddNullValueCheckToTables < ActiveRecord::Migration[5.0]
  def change
    change_column :languages, :code, :string, null: false
    change_column :part_of_speeches, :label, :string, null: false
    change_column :users, :code, :string, null: false
  end
end
