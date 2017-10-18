class LemmasController < ApplicationController
  load_and_authorize_resource

  def index
    @lemmas = Lemma.order(:id).page params[:page]
  end

  def show
    @lemma = Lemma.find(params[:id])
  end

  def new
    # tbd
  end

  def edit
    # tbd
  end

  def create
    # tbd
  end

  def update
    # tbd
  end

  def destroy
    # tbd
  end

end
