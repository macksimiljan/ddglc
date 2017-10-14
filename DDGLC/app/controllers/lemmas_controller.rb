class LemmasController < ApplicationController
  load_and_authorize_resource

  def index
    @lemmas = Lemma.order(:id).page params[:page]
  end

end
