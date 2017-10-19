class MigrateDbJob < ApplicationJob
  def perform

    greek_lemma_path = '/home/max/Schreibtisch/lexicon_greek.csv'

    InsertGreekLemmaJob.perform_now(greek_lemma_path)
  end
end