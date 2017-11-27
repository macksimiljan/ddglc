class UsagesController < ApplicationController
  load_and_authorize_resource

  def index
    persistence_id = params[:reset_filter] == 'true' ? false : 'usages#index'

    @filterrifc = initialize_filterrific(
        Usage,
        params[:filterrific],
        select_options: {
            sorted_by: Usage.options_for_sorted_by,
            with_any_created_by_ids: User.options_for_select('usages', 'created_by_id'),
            with_any_updated_by_ids: User.options_for_select('usages', 'updated_by_id'),
            with_any_usage_category_ids: UsageCategory.options_for_select,
            with_any_distinction_tier_ids: DistinctionTier.options_for_select
        },
        persistence_id: persistence_id
    ) or return


    @usages = @filterrifc.find.page(params[:page])

  rescue ActiveRecord::RecordNotFound => e
    redirect_to(reset_filterrific_url(format: :html)) and return
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