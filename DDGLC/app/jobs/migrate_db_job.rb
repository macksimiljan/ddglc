class MigrateDbJob < ApplicationJob
  def perform

    greek_lemma_path = '/home/max/Schreibtisch/lexicon_greek.csv'
    coptic_sublemma_path = '/home/max/Schreibtisch/lexicon_coptic_sublemma.csv'
    coptic_usage_path = '/home/max/Schreibtisch/lexicon_coptic.csv'

    # InsertGreekLemmaJob.perform_now greek_lemma_path
    # InsertCopticSublemmaJob.perform_now coptic_sublemma_path
    # InsertUsageJob.perform_now coptic_usage_path


    connection = ActiveRecord::Base.establish_connection.connection
    next_id = Lemma.order(id: :desc).first.id + 1
    connection.execute "ALTER SEQUENCE lemmas_id_seq START with #{next_id} RESTART;"

    next_id = Usage.order(id: :desc).first.id + 1
    connection.execute "ALTER SEQUENCE usages_id_seq START with #{next_id} RESTART;"

  end
end