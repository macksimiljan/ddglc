class LemmasController < ApplicationController
  load_and_authorize_resource

  def index
    persistence_id = params[:reset_filter] == 'true' ? false : 'lemmas#index'

    @filterrifc = initialize_filterrific(
      Lemma,
      params[:filterrific],
      select_options: {
        sorted_by: Lemma.options_for_sorted_by,
        with_part_of_speech_id: PartOfSpeech.options_for_select,
        with_any_created_by_ids: User.options_for_select('lemmas', 'created_by_id'),
        with_any_updated_by_ids: User.options_for_select('lemmas', 'updated_by_id')
      },
      persistence_id: persistence_id
    ) or return


    @lemmas = @filterrifc.find.page(params[:page])

  rescue ActiveRecord::RecordNotFound => e
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  def show
    @lemma = Lemma.find(params[:id])
  end

  def new
    @lemma = Lemma.new
  end

  def edit
    @lemma = Lemma.find(params[:id])
  end

  def create
    @lemma = Lemma.new(lemma_params)
    @lemma.created_by = current_user
    @lemma.updated_by = current_user
    if @lemma.save
      flash[:notice] = 'Successfully created new Greek lemma.'
      redirect_to lemma_path(@lemma)
    else
      flash[:warning] = 'Could not create Greek lemma.'
      render 'new'
    end
  end

  def update
    @lemma = Lemma.find(params[:id])
    if @lemma.update(lemma_params)
      flash[:notice] = 'Successfully updated Greek lemma.'
      redirect_to lemma_path(@lemma)
    else
      flash[:warning] = 'Could not update Greek lemma.'
      render 'edit'
    end
  end

  def destroy
    @lemma = Lemma.find(params[:id])
    LemmaComment.where(lemma_id: @lemma.id).delete_all
    @lemma.destroy
    redirect_to lemmas_path
  end

  private

  def lemma_params
    params.require(:lemma)
        .permit(:label, :meaning, :part_of_speech_id, :article,
                :loan_word_form, :language_id,
                :source, :reference, semantic_field_ids: [])
  end

end
