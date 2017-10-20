class MigrateDbJob < ApplicationJob
  def perform

    greek_lemma_path = '/home/max/Schreibtisch/lexicon_greek.csv'
    coptic_sublemma_path = '/home/max/Schreibtisch/lexicon_coptic_sublemma.csv'

    # InsertGreekLemmaJob.perform_now greek_lemma_path
    InsertCopticSublemmaJob.perform_now coptic_sublemma_path
  end
end