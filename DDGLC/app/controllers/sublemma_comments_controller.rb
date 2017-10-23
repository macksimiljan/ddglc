class SublemmaCommentsController < ApplicationController
  load_and_authorize_resource

  def new
    @sublemma_comment = SublemmaComment.new
  end

  def create
    @sublemma_comment = SublemmaComment.new(sublemma_comment_params)
    @sublemma_comment.updated_by = current_user
    @sublemma_comment.created_by = current_user
    if @sublemma_comment.save
      flash[:notice] = 'Comment saved.'
    else
      flash[:alert] = 'Comment could not be saved.'
    end
    redirect_to sublemma_path(sublemma_comment_params[:sublemma_id])
  end

  def destroy
    @sublemma_comment = SublemmaComment.find(params[:id])
    @sublemma_comment.delete
    redirect_to sublemma_path(@sublemma_comment.sublemma)
  end

  private

  def sublemma_comment_params
    params.require(:sublemma_comment).permit(:content, :field, :sublemma_id)
  end
end
