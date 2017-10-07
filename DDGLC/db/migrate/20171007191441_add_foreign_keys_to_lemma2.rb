class AddForeignKeysToLemma2 < ActiveRecord::Migration[5.0]
  # one-to-many: part_of_speech -- lemma
  def change
    add_reference :lemmas, :part_of_speech, foreign_key: true
  end

end
