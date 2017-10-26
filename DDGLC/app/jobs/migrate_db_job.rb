class MigrateDbJob < ApplicationJob
  def perform

    greek_lemma_path = '/home/max/Schreibtisch/lexicon_greek.csv'
    coptic_sublemma_path = '/home/max/Schreibtisch/lexicon_coptic_sublemma.csv'
    coptic_usage_path = '/home/max/Schreibtisch/lexicon_coptic.csv'

    # InsertGreekLemmaJob.perform_now greek_lemma_path
    # InsertCopticSublemmaJob.perform_now coptic_sublemma_path
    InsertUsageJob.perform_now coptic_usage_path

    #TODO: i think we have to increment the id counter manually
  end
end