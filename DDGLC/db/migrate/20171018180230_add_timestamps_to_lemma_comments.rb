class AddTimestampsToLemmaComments < ActiveRecord::Migration[5.0]
  def change
    add_column :lemma_comments, :created_at, :datetime, null: false, default: Time.now
    add_column :lemma_comments, :updated_at, :datetime, null: false, default: Time.now
  end
end

