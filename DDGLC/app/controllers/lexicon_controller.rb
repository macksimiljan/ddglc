class LexiconController < ApplicationController
  def about
    authorize! :about, :lexicon
  end
end
