class SublemmasController < ApplicationController
  load_and_authorize_resource

  def index
    persistence_id = params[:reset_filter] == 'true' ? false : 'sublemmas#index'

    @filterrifc = initialize_filterrific(
        Sublemma,
        params[:filterrific],
        select_options: {
          sorted_by: Sublemma.options_for_sorted_by,
          with_any_language_ids: Language.options_for_select,
          with_any_user_ids: User.options_for_select,
          with_part_of_speech_id: PartOfSpeech.options_for_select
        },
        persistence_id: persistence_id
    ) or return


    @sublemmas = @filterrifc.find.page(params[:page])

  rescue ActiveRecord::RecordNotFound => e
    redirect_to(reset_filterrific_url(format: :html)) and return
  end

  def show
    @sublemma = Sublemma.find(params[:id])
  end

  def new
    @sublemma = Sublemma.new(lemma_id: params[:lemma_id])
  end

  def edit
    @sublemma = Sublemma.find(params[:id])
  end

  def create
    @sublemma = Sublemma.new(sublemma_params)
    @sublemma.created_by = current_user
    @sublemma.updated_by = current_user
    if @sublemma.save
      flash[:notice] = 'Successfully created new Coptic sublemma.'
      redirect_to sublemma_path(@sublemma)
    else
      flash[:error] = 'Could not create Coptic sublemma.'
      render 'new'
    end
  end

  def update
    @sublemma = Sublemma.find(params[:id])
    if @sublemma.update(sublemma_params)
      flash[:notice] = 'Successfully updated Coptic sublemma.'
      redirect_to sublemma_path(@sublemma)
    else
      flash[:error] = 'Could not update Coptic sublemma.'
      render 'edit'
    end
  end

  def destroy
    @sublemma = Sublemma.find(params[:id])
    SublemmaComment.where(sublemma_id: @sublemma.id).delete_all
    @sublemma.destroy
    redirect_to sublemmas_path
  end

  private

  def sublemma_params
    params.require(:sublemma).permit(:label, :part_of_speech_id, :language_id, :lemma_id,
                                     :hierarchy, :loaned_form, :activated)
  end
end
