class UsagesController < ApplicationController
  load_and_authorize_resource

  def index
    @usages = Usage.order(:sublemma_id, :id).page params[:page]
  end

  def show
    @usage = Usage.find(params[:id])
  end

  def new
    @usage = Usage.new(sublemma_id: params[:sublemma_id])
  end

  def edit
    @usage = Usage.find(params[:id])
  end

  def create
    @usage = Usage.new(usage_params)
    @usage.created_by = current_user
    @usage.updated_by = current_user
    if usage_is_not_empty && @usage.save
      flash[:notice] = 'Successfully created new Coptic usage.'
      redirect_to usage_path(@usage)
    else
      flash[:error] = 'Could not create Coptic usage.'
      render 'new'
    end
  end

  def update
    @usage = Usage.find(params[:id])
    if @usage.update(usage_params)
      flash[:notice] = 'Successfully updated Coptic usage.'
      redirect_to usage_path(@usage)
    else
      flash[:error] = 'Could not update Coptic usage.'
      render 'edit'
    end
  end

  def destroy
    @usage = Usage.find(params[:id])
    UsageComment.where(usage_id: @usage.id).delete_all
    @usage.destroy
    redirect_to usages_path
  end

  private

  def usage_params
    params.require(:usage).permit(:coptic_specification, :meaning, :language_id, :sublemma_id,
                                  :hierarchy, :distinction_tier_id, :activated, :criterion,
                                  corresponding_usages: [], usage_category_ids: [])
  end

  def usage_is_not_empty
    @usage
  end
end