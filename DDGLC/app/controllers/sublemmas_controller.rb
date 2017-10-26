class SublemmasController < ApplicationController
  load_and_authorize_resource

  def index
    @sublemmas = Sublemma.order(:id).page params[:page]
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
