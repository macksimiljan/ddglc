class PartOfSpeechesController < ApplicationController
  load_and_authorize_resource

  def index
    @part_of_speeches = PartOfSpeech.all
  end
end
