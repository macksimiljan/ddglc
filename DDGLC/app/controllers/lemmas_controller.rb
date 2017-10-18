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
    @lemma = Lemma.find(params[:id])
  end

  def create
    # tbd
  end

  def update
    @lemma = Lemma.find(params[:id])
    if @lemma.update(lemma_params)
      flash[:notice] = 'Successfully updated Greek lemma.'
      redirect_to lemma_path(@lemma)
    else
      flash[:alert] = 'Could not updated Greek lemma.'
      render 'edit'
    end
  end

  def destroy
    # tbd
  end

  def add_comment
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def lemma_params
    params.require(:lemma)
        .permit(:label, :meaning, :part_of_speech_id, :article,
                :loan_word_form, :language_id, :semantic_fields,
                :source, :reference)
  end

end
