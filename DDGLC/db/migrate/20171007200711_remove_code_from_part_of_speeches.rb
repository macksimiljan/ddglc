class RemoveCodeFromPartOfSpeeches < ActiveRecord::Migration[5.0]
  def change
    remove_column :part_of_speeches, :code, :string
  end
end
