class AlterLemmaCounter < ActiveRecord::Migration[5.0]
  def change
    next_id = Lemma.order(id: :desc).first.id + 1
    execute "ALTER SEQUENCE lemmas_id_seq START with #{next_id} RESTART;"
  end
end
