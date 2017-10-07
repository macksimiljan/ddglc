class CreateLemmas < ActiveRecord::Migration[5.0]
  def change
    create_table :lemmas do |t|
      t.string :label, null: false
      t.string :article
      t.string :meaning
      t.string :loan_word_form
      t.string :source
      t.string :reference

      t.boolean :activated, default: true

      t.timestamps
    end
  end
end
